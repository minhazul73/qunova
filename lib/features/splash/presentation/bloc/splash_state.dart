part of 'splash_bloc.dart';

enum CirclePosition {
  hidden,      // Off-screen (initial and when hiding for first launch)
  corners,     // Visible in corners
  center,      // Moving/moved to center for final animation
}

enum CircleColor {
  primary,     // AppColors.primary
  white,       // White color for final animation
}

sealed class SplashState {
  final CirclePosition circlePosition;
  final CircleColor circleColor;
  final bool showOnboarding;
  final bool isAnimatingFinal;

  const SplashState({
    required this.circlePosition,
    required this.circleColor,
    this.showOnboarding = false,
    this.isAnimatingFinal = false,
  });
}

/// Initial state - only logo visible, circles hidden
final class SplashInitial extends SplashState {
  const SplashInitial()
      : super(
          circlePosition: CirclePosition.hidden,
          circleColor: CircleColor.primary,
        );
}

/// Circles are animating into corners
final class SplashCirclesVisible extends SplashState {
  const SplashCirclesVisible()
      : super(
          circlePosition: CirclePosition.corners,
          circleColor: CircleColor.primary,
        );
}

/// First launch detected - circles are hiding (animation in progress)
final class SplashShowingOnboarding extends SplashState {
  const SplashShowingOnboarding()
      : super(
          circlePosition: CirclePosition.hidden,
          circleColor: CircleColor.primary,
        );
}

/// Circles fully hidden - ready to show onboarding sheet
final class SplashOnboardingActive extends SplashState {
  const SplashOnboardingActive()
      : super(
          circlePosition: CirclePosition.hidden,
          circleColor: CircleColor.primary,
          showOnboarding: true,
        );
}

/// Final animation in progress - circles moving to center, changing color, expanding/shrinking
final class SplashFinalAnimation extends SplashState {
  const SplashFinalAnimation()
      : super(
          circlePosition: CirclePosition.center,
          circleColor: CircleColor.white,
          isAnimatingFinal: true,
        );
}

/// Animation complete - ready to navigate to main app
final class SplashReadyToNavigate extends SplashState {
  const SplashReadyToNavigate()
      : super(
          circlePosition: CirclePosition.center,
          circleColor: CircleColor.white,
        );
}
