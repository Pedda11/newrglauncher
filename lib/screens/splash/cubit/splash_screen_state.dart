part of 'splash_screen_cubit.dart';

@freezed
class SplashScreenState with _$SplashScreenState {
  const factory SplashScreenState.initial() = _initial;

  const factory SplashScreenState.initialized() = _initialized;

  const factory SplashScreenState.updateAvailable() = _updateAvailable;

  const factory SplashScreenState.failed({required String errorMsg}) = _failed;
}
