part of 'splash_bloc.dart';

sealed class SplashEvent {
  const SplashEvent();
}

/// Event to start the splash sequence
final class SplashStarted extends SplashEvent {
  const SplashStarted();
}

/// Event to animate circles into corners (after 200ms)
final class SplashCirclesAnimateIn extends SplashEvent {
  const SplashCirclesAnimateIn();
}

/// Event when first launch check is complete
final class SplashFirstLaunchChecked extends SplashEvent {
  final bool isFirstLaunch;

  const SplashFirstLaunchChecked({required this.isFirstLaunch});
}

/// Event when user completes onboarding (taps Get Started)
final class SplashOnboardingCompleted extends SplashEvent {
  const SplashOnboardingCompleted();
}

/// Event when circles finish hiding animation
final class SplashCirclesFullyHidden extends SplashEvent {
  const SplashCirclesFullyHidden();
}

/// Event to start the final transition animation
final class SplashStartFinalAnimation extends SplashEvent {
  const SplashStartFinalAnimation();
}

/// Event when final animation fully completes
final class SplashFinalAnimationComplete extends SplashEvent {
  const SplashFinalAnimationComplete();
}

/// Event when all animations are complete and ready to navigate
final class SplashNavigateToMain extends SplashEvent {
  const SplashNavigateToMain();
}
