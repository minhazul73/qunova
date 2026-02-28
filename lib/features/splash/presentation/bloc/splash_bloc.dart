import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/persistence/shared_prefs_store.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final SharedPrefsStore _prefsStore;

  SplashBloc({required SharedPrefsStore prefsStore})
      : _prefsStore = prefsStore,
        super(const SplashInitial()) {
    on<SplashStarted>(_onStarted);
    on<SplashCirclesAnimateIn>(_onCirclesAnimateIn);
    on<SplashFirstLaunchChecked>(_onFirstLaunchChecked);
    on<SplashCirclesFullyHidden>(_onCirclesFullyHidden);
    on<SplashOnboardingCompleted>(_onOnboardingCompleted);
    on<SplashStartFinalAnimation>(_onStartFinalAnimation);
    on<SplashFinalAnimationComplete>(_onFinalAnimationComplete);
    on<SplashNavigateToMain>(_onNavigateToMain);
  }

  Future<void> _onStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    emit(const SplashInitial());
    await Future.delayed(AppConstants.mediumAnimationDuration);
    add(const SplashCirclesAnimateIn());
  }

  Future<void> _onCirclesAnimateIn(
    SplashCirclesAnimateIn event,
    Emitter<SplashState> emit,
  ) async {
    emit(const SplashCirclesVisible());
    await Future.delayed(AppConstants.largeAnimationDuration);
    
    final hasSeenOnboarding = await _prefsStore.getBool(AppConstants.hasSeenOnboardingKey) ?? false;
    add(SplashFirstLaunchChecked(isFirstLaunch: !hasSeenOnboarding));
  }

  Future<void> _onFirstLaunchChecked(
    SplashFirstLaunchChecked event,
    Emitter<SplashState> emit,
  ) async {
    if (event.isFirstLaunch) {
      emit(const SplashShowingOnboarding());
      await Future.delayed(AppConstants.mediumAnimationDuration);
      add(const SplashCirclesFullyHidden());
    } else {
      await Future.delayed(AppConstants.mediumAnimationDuration);
      add(const SplashStartFinalAnimation());
    }
  }

  Future<void> _onCirclesFullyHidden(
    SplashCirclesFullyHidden event,
    Emitter<SplashState> emit,
  ) async {
    emit(const SplashOnboardingActive());
  }

  Future<void> _onOnboardingCompleted(
    SplashOnboardingCompleted event,
    Emitter<SplashState> emit,
  ) async {
    await _prefsStore.setBool(AppConstants.hasSeenOnboardingKey, true);
    await Future.delayed(AppConstants.mediumAnimationDuration);
    add(const SplashStartFinalAnimation());
  }

  Future<void> _onStartFinalAnimation(
    SplashStartFinalAnimation event,
    Emitter<SplashState> emit,
  ) async {
    emit(const SplashFinalAnimation());
    await Future.delayed(AppConstants.largeAnimationDuration);
    add(const SplashFinalAnimationComplete());
  }

  Future<void> _onFinalAnimationComplete(
    SplashFinalAnimationComplete event,
    Emitter<SplashState> emit,
  ) async {
    emit(const SplashReadyToNavigate());
    add(const SplashNavigateToMain());
  }

  void _onNavigateToMain(
    SplashNavigateToMain event,
    Emitter<SplashState> emit,
  ) {
    emit(const SplashReadyToNavigate());
  }
}
