part of 'splash_screen_cubit.dart';

@freezed
class SplashScreenState with _$SplashScreenState {
  const factory SplashScreenState.initial() = _initial;

  const factory SplashScreenState.initialized() = _initialized;

  const factory SplashScreenState.checkingForUpdates() = _checkingForUpdates;

  const factory SplashScreenState.maintenance(
      {String? motd, BannerData? banner, LinksData? links}) = _maintenance;

  const factory SplashScreenState.blockingError({required String message}) =
      _blockingError;

  const factory SplashScreenState.updateRequired(
      {String? message, required LauncherStatusData status}) = _updateRequired;

  const factory SplashScreenState.failed({required String errorMsg}) = _failed;

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    // TODO: implement debugDescribeChildren
    throw UnimplementedError();
  }

  @override
  DiagnosticsNode toDiagnosticsNode(
      {String? name, DiagnosticsTreeStyle? style}) {
    // TODO: implement toDiagnosticsNode
    throw UnimplementedError();
  }

  @override
  String toStringDeep(
      {String prefixLineOne = '',
      String? prefixOtherLines,
      DiagnosticLevel minLevel = DiagnosticLevel.debug,
      int wrapWidth = 65}) {
    // TODO: implement toStringDeep
    throw UnimplementedError();
  }

  @override
  String toStringShallow(
      {String joiner = ', ',
      DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    // TODO: implement toStringShallow
    throw UnimplementedError();
  }

  @override
  String toStringShort() {
    // TODO: implement toStringShort
    throw UnimplementedError();
  }
}
