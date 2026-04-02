import 'dart:convert';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

import '../widgets/log.dart';

class CredentialRepository {
  static const int _credType = CRED_TYPE_GENERIC;
  static const int _persist = CRED_PERSIST_LOCAL_MACHINE;

  String _credentialKey(String accountUuid) {
    return 'pedda_launcher_account_$accountUuid';
  }

  Future<void> savePassword(String accountUuid, String password) async {
    final targetNamePtr = _credentialKey(accountUuid).toNativeUtf16();
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
    final targetNamePtr = _credentialKey(accountUuid).toNativeUtf16();
    final credentialOutPtr = calloc<Pointer<CREDENTIAL>>();

    await Log.i('Attempting to read credential for accountUuId: $accountUuid');

    try {
      final result = CredRead(targetNamePtr, _credType, 0, credentialOutPtr);

      if (result == 0) {
        final error = GetLastError();

        if (error == ERROR_NOT_FOUND) {
          return null;
        }

        await Log.i('CredRead failed with error code: $error');
        throw Exception('CredRead failed. Win32 error: $error');
      }

      final credentialPtr = credentialOutPtr.value;
      final blobSize = credentialPtr.ref.CredentialBlobSize;

      if (blobSize == 0 || credentialPtr.ref.CredentialBlob == nullptr) {
        CredFree(credentialPtr);
        await Log.i(
            'Credential blob is empty or null for accountId: $accountUuid');
        return null;
      }

      final blobBytes = credentialPtr.ref.CredentialBlob.asTypedList(blobSize);
      final password = utf8.decode(blobBytes);

      await Log.i('Successfully read credential for accountId: $accountUuid');
      CredFree(credentialPtr);
      return password;
    } finally {
      calloc.free(targetNamePtr);
      calloc.free(credentialOutPtr);
    }
  }

  Future<void> deletePassword(String accountUuid) async {
    final targetNamePtr = _credentialKey(accountUuid).toNativeUtf16();

    await Log.i('Attempting to delete credential for accountId: $accountUuid');

    try {
      final result = CredDelete(targetNamePtr, _credType, 0);

      if (result == 0) {
        final error = GetLastError();

        if (error == ERROR_NOT_FOUND) {
          return;
        }

        await Log.i('CredDelete failed with error code: $error');
        throw Exception('CredDelete failed. Win32 error: $error');
      }
    } finally {
      await Log.i(
          'Finished attempting to delete credential for accountUuId: $accountUuid, freeing allocated memory');
      calloc.free(targetNamePtr);
    }
  }
}
