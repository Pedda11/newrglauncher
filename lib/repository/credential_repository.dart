import 'dart:convert';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';
import '../enum/e_credential_kind.dart';
import '../widgets/log.dart';

class CredentialRepository {
  static const int _credType = CRED_TYPE_GENERIC;
  static const int _persist = CRED_PERSIST_LOCAL_MACHINE;

  String _credentialKey(String accountUuid, ECredentialKind kind) {
    switch (kind) {
      case ECredentialKind.password:
        return 'pedda_launcher_account_${accountUuid}_password';
      case ECredentialKind.totpSecret:
        return 'pedda_launcher_account_${accountUuid}_totp_secret';
    }
  }

  Future<void> savePassword(String accountUuid, String password) async {
    final targetNamePtr =
        _credentialKey(accountUuid, ECredentialKind.password).toNativeUtf16();
    final userNamePtr = 'account_$accountUuid'.toNativeUtf16();

    await Log.i('Saving credential for accountUuId: $accountUuid');

    final passwordBytes = utf8.encode(password);
    final blobPtr = calloc<Uint8>(passwordBytes.length);

    for (var i = 0; i < passwordBytes.length; i++) {
      blobPtr[i] = passwordBytes[i];
    }

    final credentialPtr = calloc<CREDENTIAL>();

    await Log.i(
        'Prepared credential structure for accountId: $accountUuid, attempting to write to Windows Credential Manager');

    try {
      credentialPtr.ref.Flags = 0;
      credentialPtr.ref.Type = _credType;
      credentialPtr.ref.TargetName = targetNamePtr;
      credentialPtr.ref.Comment = nullptr;
      credentialPtr.ref.LastWritten.dwLowDateTime = 0;
      credentialPtr.ref.LastWritten.dwHighDateTime = 0;
      credentialPtr.ref.CredentialBlobSize = passwordBytes.length;
      credentialPtr.ref.CredentialBlob = blobPtr;
      credentialPtr.ref.Persist = _persist;
      credentialPtr.ref.AttributeCount = 0;
      credentialPtr.ref.Attributes = nullptr;
      credentialPtr.ref.TargetAlias = nullptr;
      credentialPtr.ref.UserName = userNamePtr;

      final result = CredWrite(credentialPtr, 0);

      await Log.i('CredWrite result for accountId: $accountUuid: $result');

      if (result == 0) {
        final error = GetLastError();
        throw Exception('CredWrite failed. Win32 error: $error');
      }
    } finally {
      await Log.i(
          'Finished attempting to save credential for accountId: $accountUuid, freeing allocated memory');
      calloc.free(credentialPtr);
      calloc.free(blobPtr);
      calloc.free(targetNamePtr);
      calloc.free(userNamePtr);
    }
  }

  Future<String?> readPassword(String accountUuid) async {
    var targetNamePtr =
        _credentialKey(accountUuid, ECredentialKind.password).toNativeUtf16();
    final credentialOutPtr = calloc<Pointer<CREDENTIAL>>();

    await Log.i('Attempting to read credential for accountUuId: $accountUuid');

    try {
      final result = CredRead(targetNamePtr, _credType, 0, credentialOutPtr);

      if (result == 0) {
        final error = GetLastError();

        if (error == ERROR_NOT_FOUND) {
          calloc.free(targetNamePtr);
          targetNamePtr = nullptr;

          final legacyTargetNamePtr =
              _legacyPasswordCredentialKey(accountUuid).toNativeUtf16();

          try {
            await Log.i(
              'Password not found under new key for accountId: $accountUuid, trying legacy key',
            );

            final legacyResult =
                CredRead(legacyTargetNamePtr, _credType, 0, credentialOutPtr);

            if (legacyResult == 0) {
              final legacyError = GetLastError();

              if (legacyError == ERROR_NOT_FOUND) {
                return null;
              }

              await Log.i(
                'Legacy CredRead failed with error code: $legacyError',
              );
              throw Exception(
                'Legacy CredRead failed. Win32 error: $legacyError',
              );
            }
          } finally {
            calloc.free(legacyTargetNamePtr);
          }
        } else {
          await Log.i('CredRead failed with error code: $error');
          throw Exception('CredRead failed. Win32 error: $error');
        }
      }

      final credentialPtr = credentialOutPtr.value;
      final blobSize = credentialPtr.ref.CredentialBlobSize;

      if (blobSize == 0 || credentialPtr.ref.CredentialBlob == nullptr) {
        CredFree(credentialPtr);
        await Log.i(
          'Credential blob is empty or null for accountId: $accountUuid',
        );
        return null;
      }

      final blobBytes = credentialPtr.ref.CredentialBlob.asTypedList(blobSize);
      final password = utf8.decode(blobBytes);

      await Log.i('Successfully read credential for accountId: $accountUuid');
      CredFree(credentialPtr);
      return password;
    } finally {
      if (targetNamePtr != nullptr) {
        calloc.free(targetNamePtr);
      }
      calloc.free(credentialOutPtr);
    }
  }

  Future<void> deletePassword(String accountUuid) async {
    final targetNamePtr =
        _credentialKey(accountUuid, ECredentialKind.password).toNativeUtf16();
    final legacyTargetNamePtr =
        _legacyPasswordCredentialKey(accountUuid).toNativeUtf16();

    await Log.i('Attempting to delete credential for accountId: $accountUuid');

    try {
      final result = CredDelete(targetNamePtr, _credType, 0);

      if (result == 0) {
        final error = GetLastError();

        if (error != ERROR_NOT_FOUND) {
          await Log.i('CredDelete failed with error code: $error');
          throw Exception('CredDelete failed. Win32 error: $error');
        }
      }

      final legacyResult = CredDelete(legacyTargetNamePtr, _credType, 0);

      if (legacyResult == 0) {
        final legacyError = GetLastError();

        if (legacyError != ERROR_NOT_FOUND) {
          await Log.i('Legacy CredDelete failed with error code: $legacyError');
          throw Exception(
            'Legacy CredDelete failed. Win32 error: $legacyError',
          );
        }
      }
    } finally {
      await Log.i(
        'Finished attempting to delete credential for accountUuId: $accountUuid, freeing allocated memory',
      );
      calloc.free(targetNamePtr);
      calloc.free(legacyTargetNamePtr);
    }
  }

  String _legacyPasswordCredentialKey(String accountUuid) {
    return 'pedda_launcher_account_$accountUuid';
  }

  Future<void> saveTotpSecret(String accountUuid, String secret) async {
    final targetNamePtr =
        _credentialKey(accountUuid, ECredentialKind.totpSecret).toNativeUtf16();
    final userNamePtr = 'account_${accountUuid}_totp'.toNativeUtf16();

    await Log.i('Saving TOTP secret for accountId: $accountUuid');

    final normalizedSecret = _normalizeTotpSecret(secret);
    final secretBytes = utf8.encode(normalizedSecret);
    final blobPtr = calloc<Uint8>(secretBytes.length);

    for (var i = 0; i < secretBytes.length; i++) {
      blobPtr[i] = secretBytes[i];
    }

    final credentialPtr = calloc<CREDENTIAL>();

    await Log.i(
      'Prepared TOTP credential structure for accountId: $accountUuid, attempting to write to Windows Credential Manager',
    );

    try {
      credentialPtr.ref.Flags = 0;
      credentialPtr.ref.Type = _credType;
      credentialPtr.ref.TargetName = targetNamePtr;
      credentialPtr.ref.Comment = nullptr;
      credentialPtr.ref.LastWritten.dwLowDateTime = 0;
      credentialPtr.ref.LastWritten.dwHighDateTime = 0;
      credentialPtr.ref.CredentialBlobSize = secretBytes.length;
      credentialPtr.ref.CredentialBlob = blobPtr;
      credentialPtr.ref.Persist = _persist;
      credentialPtr.ref.AttributeCount = 0;
      credentialPtr.ref.Attributes = nullptr;
      credentialPtr.ref.TargetAlias = nullptr;
      credentialPtr.ref.UserName = userNamePtr;

      final result = CredWrite(credentialPtr, 0);

      await Log.i(
          'CredWrite result for TOTP secret accountId: $accountUuid: $result');

      if (result == 0) {
        final error = GetLastError();
        throw Exception(
            'CredWrite for TOTP secret failed. Win32 error: $error');
      }
    } finally {
      await Log.i(
        'Finished attempting to save TOTP secret for accountId: $accountUuid, freeing allocated memory',
      );
      calloc.free(credentialPtr);
      calloc.free(blobPtr);
      calloc.free(targetNamePtr);
      calloc.free(userNamePtr);
    }
  }

  Future<String?> readTotpSecret(String accountUuid) async {
    final targetNamePtr =
        _credentialKey(accountUuid, ECredentialKind.totpSecret).toNativeUtf16();
    final credentialOutPtr = calloc<Pointer<CREDENTIAL>>();

    await Log.i('Attempting to read TOTP secret for accountId: $accountUuid');

    try {
      final result = CredRead(targetNamePtr, _credType, 0, credentialOutPtr);

      if (result == 0) {
        final error = GetLastError();

        if (error == ERROR_NOT_FOUND) {
          return null;
        }

        await Log.i('CredRead for TOTP secret failed with error code: $error');
        throw Exception('CredRead for TOTP secret failed. Win32 error: $error');
      }

      final credentialPtr = credentialOutPtr.value;
      final blobSize = credentialPtr.ref.CredentialBlobSize;

      if (blobSize == 0 || credentialPtr.ref.CredentialBlob == nullptr) {
        CredFree(credentialPtr);
        await Log.i(
          'TOTP credential blob is empty or null for accountId: $accountUuid',
        );
        return null;
      }

      final blobBytes = credentialPtr.ref.CredentialBlob.asTypedList(blobSize);
      final secret = utf8.decode(blobBytes);

      await Log.i('Successfully read TOTP secret for accountId: $accountUuid');
      CredFree(credentialPtr);
      return secret;
    } finally {
      calloc.free(targetNamePtr);
      calloc.free(credentialOutPtr);
    }
  }

  Future<void> deleteTotpSecret(String accountUuid) async {
    final targetNamePtr =
        _credentialKey(accountUuid, ECredentialKind.totpSecret).toNativeUtf16();

    await Log.i('Attempting to delete TOTP secret for accountId: $accountUuid');

    try {
      final result = CredDelete(targetNamePtr, _credType, 0);

      if (result == 0) {
        final error = GetLastError();

        if (error == ERROR_NOT_FOUND) {
          return;
        }

        await Log.i(
            'CredDelete for TOTP secret failed with error code: $error');
        throw Exception(
            'CredDelete for TOTP secret failed. Win32 error: $error');
      }
    } finally {
      await Log.i(
        'Finished attempting to delete TOTP secret for accountId: $accountUuid, freeing allocated memory',
      );
      calloc.free(targetNamePtr);
    }
  }

  String _normalizeTotpSecret(String secret) {
    return secret.replaceAll(' ', '').replaceAll('-', '').trim().toUpperCase();
  }
}
