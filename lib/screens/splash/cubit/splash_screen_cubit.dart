import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/shared_preferences_settings.dart';
import '../../../repository/main_repository.dart';

part 'splash_screen_state.dart';

part 'splash_screen_cubit.freezed.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  final MainRepository mainRepository;

  SplashScreenCubit(this.mainRepository)
      : super(const SplashScreenState.initial());

  void initialize() async {}

  void _checkForPIN() async {}
}
