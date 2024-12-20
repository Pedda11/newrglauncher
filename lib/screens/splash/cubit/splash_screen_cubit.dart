import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../services/update_service.dart';

part 'splash_screen_state.dart';

part 'splash_screen_cubit.freezed.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  SplashScreenCubit() : super(const SplashScreenState.initial());

  void initialize() async {
    try {
      await UpdateService().deleteUpdateFiles();
      UpdateService().checkForUpdate().then((value) async {
        if (value) {
          emit(const SplashScreenState.updateAvailable());
        } else {
          emit(const SplashScreenState.initialized());
        }
      });
    } catch (e) {
      emit(SplashScreenState.failed(errorMsg: e.toString()));
    }
  }
}
