import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../contacts/presentation/pages/contacts_page.dart';
import '../bloc/splash_bloc.dart';
import '../constants/splash_constants.dart';
import '../models/circle_position_data.dart';
import '../widgets/animated_circle.dart';
import '../widgets/first_launch_sheet.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static const String name = 'splash';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashBloc>(
      create: (context) => sl<SplashBloc>()..add(const SplashStarted()),
      child: const _SplashPageContent(),
    );
  }
}

class _SplashPageContent extends StatefulWidget {
  const _SplashPageContent();

  @override
  State<_SplashPageContent> createState() => _SplashPageContentState();
}

class _SplashPageContentState extends State<_SplashPageContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sheetController;

  @override
  void initState() {
    super.initState();
    _sheetController = AnimationController(
      vsync: this,
      duration: AppConstants.mediumAnimationDuration,
    );
    // Hide status bar and navigation bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    _sheetController.dispose();
    // Restore status bar and navigation bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _showOnboardingSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      transitionAnimationController: _sheetController,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (sheetContext) {
        return FirstLaunchSheet(
          onGetStarted: () {
            Navigator.of(sheetContext).pop();
            context.read<SplashBloc>().add(const SplashOnboardingCompleted());
          },
        );
      },
    );
  }

  ({
    CirclePositionData topCircle,
    CirclePositionData bottomCircle,
    Color color,
    Duration duration,
  }) _calculateCirclePositions(
    SplashState state,
    double width,
    double height,
  ) {
    final bottomCircleRadius = width * SplashConstants.bottomCircleRadiusRatio;
    final topCircleRadius = width * SplashConstants.topCircleRadiusRatio;
    final loaderRadius = width * SplashConstants.loaderRadiusRatio;

    late CirclePositionData topCircle;
    late CirclePositionData bottomCircle;
    late Color circleColor;
    late Duration circleDuration;

    switch (state.circlePosition) {
      case CirclePosition.hidden:
        topCircle = CirclePositionData.top(
          topPosition: -topCircleRadius * 2,
          rightPosition: -topCircleRadius * 2,
          size: topCircleRadius * 2,
        );
        bottomCircle = CirclePositionData.bottom(
          bottomPosition: -bottomCircleRadius * 2,
          leftPosition: -bottomCircleRadius * 2,
          size: bottomCircleRadius * 2,
        );
        break;

      case CirclePosition.corners:
        topCircle = CirclePositionData.top(
          topPosition: -topCircleRadius,
          rightPosition: -topCircleRadius,
          size: topCircleRadius * 2,
        );
        bottomCircle = CirclePositionData.bottom(
          bottomPosition: -bottomCircleRadius,
          leftPosition: -bottomCircleRadius,
          size: bottomCircleRadius * 2,
        );
        break;

      case CirclePosition.center:
        if (state.isAnimatingFinal) {
          bottomCircle = CirclePositionData.bottom(
            bottomPosition: height / 2 - loaderRadius,
            leftPosition: width / 2 - loaderRadius,
            size: loaderRadius * 2,
          );
          final maxDimension = width > height ? width : height;
          final expandedSize = maxDimension * 1.5;
          topCircle = CirclePositionData.top(
            topPosition: height / 2 - expandedSize / 2,
            rightPosition: width / 2 - expandedSize / 2,
            size: expandedSize,
          );
        } else {
          topCircle = CirclePositionData.top(
            topPosition: height / 2 - topCircleRadius,
            rightPosition: width / 2 - topCircleRadius,
            size: topCircleRadius * 2,
          );
          bottomCircle = CirclePositionData.bottom(
            bottomPosition: height / 2 - bottomCircleRadius,
            leftPosition: width / 2 - bottomCircleRadius,
            size: bottomCircleRadius * 2,
          );
        }
        break;
    }

    circleColor = state.circleColor == CircleColor.white
        ? AppColors.background
        : AppColors.primary;

    circleDuration = state.circlePosition == CirclePosition.center
        ? AppConstants.largeAnimationDuration
        : AppConstants.mediumAnimationDuration;

    return (
      topCircle: topCircle,
      bottomCircle: bottomCircle,
      color: circleColor,
      duration: circleDuration,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashReadyToNavigate) {
          context.goNamed(ContactsPage.name);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocBuilder<SplashBloc, SplashState>(
          builder: (context, state) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final positionData = _calculateCirclePositions(
                  state,
                  constraints.maxWidth,
                  constraints.maxHeight,
                );

                return Stack(
                  children: [
                    // Animated Logo
                    _buildAnimatedLogo(state),

                    // Onboarding Sheet Listener
                    BlocListener<SplashBloc, SplashState>(
                      listener: (context, state) {
                        if (state is SplashOnboardingActive) {
                          _showOnboardingSheet(context);
                        }
                      },
                      child: const SizedBox.shrink(),
                    ),

                    // Top Circle
                    AnimatedCircle(
                      duration: positionData.duration.inMilliseconds.toDouble(),
                      top: positionData.topCircle.topPosition,
                      right: positionData.topCircle.rightPosition,
                      size: positionData.topCircle.size,
                      color: positionData.color,
                    ),

                    // Bottom Circle
                    AnimatedCircle(
                      duration: positionData.duration.inMilliseconds.toDouble(),
                      bottom: positionData.bottomCircle.bottomPosition,
                      left: positionData.bottomCircle.leftPosition,
                      size: positionData.bottomCircle.size,
                      color: positionData.color,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo(SplashState state) {
    final scale = state is SplashOnboardingActive
        ? SplashConstants.logoScaleOnboarding
        : 1.0;
    final alignment = state is SplashOnboardingActive
        ? const Alignment(0, SplashConstants.logoAlignmentYOnboarding)
        : Alignment.center;

    return AnimatedAlign(
      duration: AppConstants.mediumAnimationDuration,
      curve: Curves.linearToEaseOut,
      alignment: alignment,
      child: AnimatedScale(
        scale: scale,
        duration: AppConstants.mediumAnimationDuration,
        curve: Curves.linearToEaseOut,
        alignment: Alignment.center,
        child: Image.asset(
          AppConstants.appBrand,
        ),
      ),
    );
  }
}
