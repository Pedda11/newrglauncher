import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:win32/win32.dart';

import 'application.dart';
import 'widgets/repository_container.dart';

const int TokenElevation = 20;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isAdmin = isRunningAsAdmin();
  debugPrint('RUNNING AS ADMIN: $isAdmin');

  final sharedPreferences = SharedPreferencesAsync();

  runApp(
    RepositoryContainer(
      sharedPreferences: sharedPreferences,
      child: const Application(),
    ),
  );
}

bool isRunningAsAdmin() {
  final tokenHandlePointer = calloc<IntPtr>();
  final elevationValuePointer = calloc<Uint32>();
  final returnLengthPointer = calloc<Uint32>();

  try {
    final openTokenResult = OpenProcessToken(
      GetCurrentProcess(),
      TOKEN_QUERY,
      tokenHandlePointer,
    );

    if (openTokenResult == 0) {
      return false;
    }

    final tokenInfoResult = GetTokenInformation(
      tokenHandlePointer.value,
      TokenElevation,
      elevationValuePointer.cast(),
      sizeOf<Uint32>(),
      returnLengthPointer,
    );

    if (tokenInfoResult == 0) {
      return false;
    }

    return elevationValuePointer.value != 0;
  } finally {
    if (tokenHandlePointer.value != 0) {
      CloseHandle(tokenHandlePointer.value);
    }

    calloc.free(tokenHandlePointer);
    calloc.free(elevationValuePointer);
    calloc.free(returnLengthPointer);
  }
}
