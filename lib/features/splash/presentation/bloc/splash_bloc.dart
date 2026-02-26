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
    // Start with initial state (logo only)
    emit(const SplashInitial());

    // Wait 200ms then animate circles in
    await Future.delayed(const Duration(milliseconds: 200));
    add(const SplashCirclesAnimateIn());
  }

  Future<void> _onCirclesAnimateIn(
    SplashCirclesAnimateIn event,
    Emitter<SplashState> emit,
  ) async {
    // Animate circles into corners
    emit(const SplashCirclesVisible());

    // Wait for animation to complete, then check first launch
    await Future.delayed(AppConstants.mediumAnimationDuration * 3);

    // Check if first launch
    final hasSeenOnboarding =
        await _prefsStore.getBool(AppConstants.hasSeenOnboardingKey) ?? false;
    add(SplashFirstLaunchChecked(isFirstLaunch: !hasSeenOnboarding));
  }

  Future<void> _onFirstLaunchChecked(
    SplashFirstLaunchChecked event,
    Emitter<SplashState> emit,
  ) async {
    if (event.isFirstLaunch) {
      // First launch: hide circles
      emit(const SplashShowingOnboarding());
      // Wait for hide animation to complete
      await Future.delayed(AppConstants.mediumAnimationDuration).then((_) {
        // Circles are fully hidden, now ready to show sheet
        add(const SplashCirclesFullyHidden());
      });
      ;
    } else {
      // Returning user: proceed directly to final animation
      await Future.delayed(AppConstants.mediumAnimationDuration).then((_) {
        add(const SplashStartFinalAnimation());
      });
    }
  }

  Future<void> _onCirclesFullyHidden(
    SplashCirclesFullyHidden event,
    Emitter<SplashState> emit,
  ) async {
    // Circles are fully hidden, show the onboarding sheet
    emit(const SplashOnboardingActive());
  }

  Future<void> _onOnboardingCompleted(
    SplashOnboardingCompleted event,
    Emitter<SplashState> emit,
  ) async {
    // Save that onboarding has been seen
    await _prefsStore.setBool(AppConstants.hasSeenOnboardingKey, true);

    // Start final animation
    await Future.delayed(AppConstants.mediumAnimationDuration).then((_) {
      add(const SplashStartFinalAnimation());
    });
  }

  Future<void> _onStartFinalAnimation(
    SplashStartFinalAnimation event,
    Emitter<SplashState> emit,
  ) async {
    // Trigger final animation: circles to center, color to white, expand/shrink
    emit(const SplashFinalAnimation());

    // Wait for final animation to complete
    await Future.delayed(AppConstants.mediumAnimationDuration * 3);

    // Animation is fully complete
    add(const SplashFinalAnimationComplete());
  }

  Future<void> _onFinalAnimationComplete(
    SplashFinalAnimationComplete event,
    Emitter<SplashState> emit,
  ) async {
    // Animation complete, ready to navigate
    emit(const SplashReadyToNavigate());

    // Delay slightly before navigating to allow animations to settle
    await Future.delayed(const Duration(milliseconds: 100));

    // Navigate to main app
    add(const SplashNavigateToMain());
  }

  void _onNavigateToMain(
    SplashNavigateToMain event,
    Emitter<SplashState> emit,
  ) {
    emit(const SplashReadyToNavigate());
  }
}
