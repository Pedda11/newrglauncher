import 'dart:ffi';

typedef _GetCurrentProcessIdNative = Uint32 Function();
typedef _GetCurrentProcessIdDart = int Function();

class ProcessInfoUtil {
  static final DynamicLibrary _kernel32 = DynamicLibrary.open('kernel32.dll');

  static final _GetCurrentProcessIdDart _getCurrentProcessId = _kernel32
      .lookupFunction<_GetCurrentProcessIdNative, _GetCurrentProcessIdDart>(
    'GetCurrentProcessId',
  );

  static int currentPid() {
    return _getCurrentProcessId();
  }
}
