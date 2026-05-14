import 'dart:convert';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';
import '../enum/e_credential_kind.dart';
import '../widgets/log.dart';

class CredentialRepository {
  static const int _credType = CRED_TYPE_GENERIC;
  static const int _persist = CRED_PERSIST_LOCAL_MACHINE;

  Future<String?> _readCredentialValueWithRetry(
    Pointer<Utf16> targetNamePtr, {
    required String logContext,
    int maxAttempts = 3,
  }) async {
    final credentialOutPtr = calloc<Pointer<CREDENTIAL>>();

    try {
      for (var attempt = 1; attempt <= maxAttempts; attempt++) {
        final result = CredRead(targetNamePtr, _credType, 0, credentialOutPtr);

        if (result != 0) {
          await Log.info(
              'CredRead succeeded for $logContext on attempt $attempt');

          final credentialPtr = credentialOutPtr.value;
          final blobSize = credentialPtr.ref.CredentialBlobSize;

          if (blobSize == 0 || credentialPtr.ref.CredentialBlob == nullptr) {
            CredFree(credentialPtr);
            await Log.info(
              'Credential blob is empty or null for $logContext',
            );
            return null;
          }

          final blobBytes =
              credentialPtr.ref.CredentialBlob.asTypedList(blobSize);
          final value = utf8.decode(blobBytes);

          await Log.info('Successfully read credential for $logContext');
          CredFree(credentialPtr);
          return value;
        }

        final error = GetLastError();
        await Log.info('CredRead result: $result, error: $error');

        if (error == ERROR_NOT_FOUND) {
          return null;
        }

        /// Retry flaky first-read failures where CredRead fails but GetLastError stays 0.
        if (error == ERROR_SUCCESS && attempt < maxAttempts) {
          await Log.info(
            'CredRead failed without Win32 error, retrying ($attempt/$maxAttempts)',
          );
          await Future.delayed(const Duration(milliseconds: 200));
          continue;
        }

        await Log.info(
          'CredRead failed for $logContext with error code: $error on attempt $attempt',
        );

        if (error == ERROR_SUCCESS) {
          throw Exception(
            'CredRead failed without Win32 error after $attempt attempts.',
          );
        }

        throw Exception('CredRead failed. Win32 error: $error');
      }

      return null;
    } finally {
      calloc.free(credentialOutPtr);
    }
  }

  String _credentialKey(String accountUuid, ECredentialKind kind) {
    switch (kind) {
      case ECredentialKind.password:
        return 'pedda_launcher_account_${accountUuid}_password';
      case ECredentialKind.totpSecret:
        return 'pedda_launcher_account_${accountUuid}_totp_secret';
      case ECredentialKind.launcherPin:
        throw ArgumentError('Launcher PIN is not account-bound');
    }
  }

  String _globalCredentialKey(ECredentialKind kind) {
    switch (kind) {
      case ECredentialKind.launcherPin:
        return 'pedda_launcher_global_pin_v1';
      case ECredentialKind.password:
      case ECredentialKind.totpSecret:
        throw ArgumentError(
          'Use account credential key for account-bound secrets',
        );
    }
  }

  String _legacyPasswordCredentialKey(String accountUuid) {
    return 'pedda_launcher_account_$accountUuid';
  }

  String _normalizeTotpSecret(String secret) {
    return secret.replaceAll(' ', '').replaceAll('-', '').trim().toUpperCase();
  }

  Future<void> savePassword(String accountUuid, String password) async {
    final targetNamePtr =
        _credentialKey(accountUuid, ECredentialKind.password).toNativeUtf16();
    final userNamePtr = 'account_$accountUuid'.toNativeUtf16();

    await Log.info('Saving credential for accountUuId: $accountUuid');

    final passwordBytes = utf8.encode(password);
    final blobPtr = calloc<Uint8>(passwordBytes.length);

    for (var i = 0; i < passwordBytes.length; i++) {
      blobPtr[i] = passwordBytes[i];
    }

    final credentialPtr = calloc<CREDENTIAL>();

    await Log.info(
      'Prepared credential structure for accountId: $accountUuid, attempting to write to Windows Credential Manager',
    );

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

      await Log.info('CredWrite result for accountId: $accountUuid: $result');

      if (result == 0) {
        final error = GetLastError();
        throw Exception('CredWrite failed. Win32 error: $error');
      }
    } finally {
      await Log.info(
        'Finished attempting to save credential for accountId: $accountUuid, freeing allocated memory',
      );
      calloc.free(credentialPtr);
      calloc.free(blobPtr);
      calloc.free(targetNamePtr);
      calloc.free(userNamePtr);
    }
  }

  Future<String?> readPassword(String accountUuid) async {
    var targetNamePtr =
        _credentialKey(accountUuid, ECredentialKind.password).toNativeUtf16();

    await Log.info(
        'Attempting to read credential for accountUuId: $accountUuid');

    try {
      final password = await _readCredentialValueWithRetry(
        targetNamePtr,
        logContext: 'accountId: $accountUuid',
      );

      if (password != null) {
        return password;
      }
    } finally {
      if (targetNamePtr != nullptr) {
        calloc.free(targetNamePtr);
      }
    }

    final legacyTargetNamePtr =
        _legacyPasswordCredentialKey(accountUuid).toNativeUtf16();

    try {
      await Log.info(
        'Password not found under new key for accountId: $accountUuid, trying legacy key',
      );

      return await _readCredentialValueWithRetry(
        legacyTargetNamePtr,
        logContext: 'legacy accountId: $accountUuid',
      );
    } finally {
      calloc.free(legacyTargetNamePtr);
    }
  }

  Future<void> deletePassword(String accountUuid) async {
    final targetNamePtr =
        _credentialKey(accountUuid, ECredentialKind.password).toNativeUtf16();
    final legacyTargetNamePtr =
        _legacyPasswordCredentialKey(accountUuid).toNativeUtf16();

    await Log.info(
        'Attempting to delete credential for accountId: $accountUuid');

    try {
      final result = CredDelete(targetNamePtr, _credType, 0);

      if (result == 0) {
        final error = GetLastError();

        if (error != ERROR_NOT_FOUND) {
          await Log.info('CredDelete failed with error code: $error');
          throw Exception('CredDelete failed. Win32 error: $error');
        }
      }

      final legacyResult = CredDelete(legacyTargetNamePtr, _credType, 0);

      if (legacyResult == 0) {
        final legacyError = GetLastError();

        if (legacyError != ERROR_NOT_FOUND) {
          await Log.info(
              'Legacy CredDelete failed with error code: $legacyError');
          throw Exception(
            'Legacy CredDelete failed. Win32 error: $legacyError',
          );
        }
      }
    } finally {
      await Log.info(
        'Finished attempting to delete credential for accountUuId: $accountUuid, freeing allocated memory',
      );
      calloc.free(targetNamePtr);
      calloc.free(legacyTargetNamePtr);
    }
  }

  Future<void> saveTotpSecret(String accountUuid, String secret) async {
    final targetNamePtr =
        _credentialKey(accountUuid, ECredentialKind.totpSecret).toNativeUtf16();
    final userNamePtr = 'account_${accountUuid}_totp'.toNativeUtf16();

    await Log.info('Saving TOTP secret for accountId: $accountUuid');

    final normalizedSecret = _normalizeTotpSecret(secret);
    final secretBytes = utf8.encode(normalizedSecret);
    final blobPtr = calloc<Uint8>(secretBytes.length);

    for (var i = 0; i < secretBytes.length; i++) {
      blobPtr[i] = secretBytes[i];
    }

    final credentialPtr = calloc<CREDENTIAL>();

    await Log.info(
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

      await Log.info(
        'CredWrite result for TOTP secret accountId: $accountUuid: $result',
      );

      if (result == 0) {
        final error = GetLastError();
        throw Exception(
          'CredWrite for TOTP secret failed. Win32 error: $error',
        );
      }
    } finally {
      await Log.info(
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

    await Log.info(
        'Attempting to read TOTP secret for accountId: $accountUuid');

    try {
      return await _readCredentialValueWithRetry(
        targetNamePtr,
        logContext: 'TOTP accountId: $accountUuid',
      );
    } finally {
      calloc.free(targetNamePtr);
    }
  }

  Future<void> deleteTotpSecret(String accountUuid) async {
    final targetNamePtr =
        _credentialKey(accountUuid, ECredentialKind.totpSecret).toNativeUtf16();

    await Log.info(
        'Attempting to delete TOTP secret for accountId: $accountUuid');

    try {
      final result = CredDelete(targetNamePtr, _credType, 0);

      if (result == 0) {
        final error = GetLastError();

        if (error == ERROR_NOT_FOUND) {
          return;
        }

        await Log.info(
          'CredDelete for TOTP secret failed with error code: $error',
        );
        throw Exception(
          'CredDelete for TOTP secret failed. Win32 error: $error',
        );
      }
    } finally {
      await Log.info(
        'Finished attempting to delete TOTP secret for accountId: $accountUuid, freeing allocated memory',
      );
      calloc.free(targetNamePtr);
    }
  }

  Future<void> saveLauncherPin(String jsonPayload) async {
    final targetNamePtr =
        _globalCredentialKey(ECredentialKind.launcherPin).toNativeUtf16();
    final userNamePtr = 'launcher_pin'.toNativeUtf16();

    await Log.info('Saving launcher PIN');

    final bytes = utf8.encode(jsonPayload);
    final blobPtr = calloc<Uint8>(bytes.length);

    for (var i = 0; i < bytes.length; i++) {
      blobPtr[i] = bytes[i];
    }

    final credentialPtr = calloc<CREDENTIAL>();

    try {
      credentialPtr.ref.Flags = 0;
      credentialPtr.ref.Type = _credType;
      credentialPtr.ref.TargetName = targetNamePtr;
      credentialPtr.ref.Comment = nullptr;
      credentialPtr.ref.LastWritten.dwLowDateTime = 0;
      credentialPtr.ref.LastWritten.dwHighDateTime = 0;
      credentialPtr.ref.CredentialBlobSize = bytes.length;
      credentialPtr.ref.CredentialBlob = blobPtr;
      credentialPtr.ref.Persist = _persist;
      credentialPtr.ref.AttributeCount = 0;
      credentialPtr.ref.Attributes = nullptr;
      credentialPtr.ref.TargetAlias = nullptr;
      credentialPtr.ref.UserName = userNamePtr;

      final result = CredWrite(credentialPtr, 0);

      if (result == 0) {
        final error = GetLastError();
        throw Exception('CredWrite launcher PIN failed. Win32 error: $error');
      }
    } finally {
      calloc.free(credentialPtr);
      calloc.free(blobPtr);
      calloc.free(targetNamePtr);
      calloc.free(userNamePtr);
    }
  }

  Future<String?> readLauncherPin() async {
    final targetNamePtr =
        _globalCredentialKey(ECredentialKind.launcherPin).toNativeUtf16();

    await Log.info('Reading launcher PIN');

    try {
      return await _readCredentialValueWithRetry(
        targetNamePtr,
        logContext: 'launcher PIN',
      );
    } finally {
      calloc.free(targetNamePtr);
    }
  }

  Future<void> deleteLauncherPin() async {
    final targetNamePtr =
        _globalCredentialKey(ECredentialKind.launcherPin).toNativeUtf16();

    await Log.info('Deleting launcher PIN');

    try {
      final result = CredDelete(targetNamePtr, _credType, 0);

      if (result == 0) {
        final error = GetLastError();
        if (error != ERROR_NOT_FOUND) {
          throw Exception(
              'CredDelete launcher PIN failed. Win32 error: $error');
        }
      }
    } finally {
      calloc.free(targetNamePtr);
    }
  }
}
