part of 'splash_bloc.dart';

sealed class SplashEvent {
  const SplashEvent();
}

final class SplashStarted extends SplashEvent {
  const SplashStarted();
}

final class SplashCirclesAnimateIn extends SplashEvent {
  const SplashCirclesAnimateIn();
}

final class SplashFirstLaunchChecked extends SplashEvent {
  final bool isFirstLaunch;

  const SplashFirstLaunchChecked({required this.isFirstLaunch});
}

final class SplashOnboardingCompleted extends SplashEvent {
  const SplashOnboardingCompleted();
}

final class SplashCirclesFullyHidden extends SplashEvent {
  const SplashCirclesFullyHidden();
}

final class SplashStartFinalAnimation extends SplashEvent {
  const SplashStartFinalAnimation();
}

final class SplashFinalAnimationComplete extends SplashEvent {
  const SplashFinalAnimationComplete();
}

final class SplashNavigateToMain extends SplashEvent {
  const SplashNavigateToMain();
}
