import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/persistence/shared_prefs_store.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../contacts/presentation/pages/contacts_page.dart';
import '../bloc/splash_bloc.dart';
import '../widgets/first_launch_sheet.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static const String name = 'splash';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPrefsStore>(
      future: SharedPrefsStore.create(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return BlocProvider(
          create: (context) => SplashBloc(
            prefsStore: snapshot.data!,
          )..add(const SplashStarted()),
          child: const _SplashPageContent(),
        );
      },
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
      duration: const Duration(milliseconds: 450),
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
                final width = constraints.maxWidth;
                final height = constraints.maxHeight;

                final bottomCircleRadius = width * .3;
                final topCircleRadius = width * .2;
                final loaderRadius = width * .05;

                // Calculate positions based on state
                double bottomCircleBottom;
                double bottomCircleLeft;
                double bottomCircleSize;

                double topCircleTop;
                double topCircleRight;
                double topCircleSize;

                Color circlesColor;

                switch (state.circlePosition) {
                  case CirclePosition.hidden:
                    // Fully off-screen
                    bottomCircleBottom = -bottomCircleRadius * 2;
                    bottomCircleLeft = -bottomCircleRadius * 2;
                    bottomCircleSize = bottomCircleRadius * 2;

                    topCircleTop = -topCircleRadius * 2;
                    topCircleRight = -topCircleRadius * 2;
                    topCircleSize = topCircleRadius * 2;
                    break;

                  case CirclePosition.corners:
                    // Partially visible in corners
                    bottomCircleBottom = -bottomCircleRadius;
                    bottomCircleLeft = -bottomCircleRadius;
                    bottomCircleSize = bottomCircleRadius * 2;

                    topCircleTop = -topCircleRadius;
                    topCircleRight = -topCircleRadius;
                    topCircleSize = topCircleRadius * 2;
                    break;

                  case CirclePosition.center:
                    // Moving to center with size changes
                    if (state.isAnimatingFinal) {
                      // Small circle shrinks to loader size at center
                      bottomCircleBottom = height / 2 - loaderRadius;
                      bottomCircleLeft = width / 2 - loaderRadius;
                      bottomCircleSize = loaderRadius * 2;

                      // Large circle expands to cover screen from center
                      final maxDimension = width > height ? width : height;
                      final expandedSize = maxDimension * 1.5;
                      topCircleTop = height / 2 - expandedSize / 2;
                      topCircleRight = width / 2 - expandedSize / 2;
                      topCircleSize = expandedSize;
                    } else {
                      // Default center positions
                      bottomCircleBottom = height / 2 - bottomCircleRadius;
                      bottomCircleLeft = width / 2 - bottomCircleRadius;
                      bottomCircleSize = bottomCircleRadius * 2;

                      topCircleTop = height / 2 - topCircleRadius;
                      topCircleRight = width / 2 - topCircleRadius;
                      topCircleSize = topCircleRadius * 2;
                    }
                    break;
                }

                circlesColor = state.circleColor == CircleColor.white
                    ? Colors.white
                    : AppColors.primary;

                final circleDuration =
                    state.circlePosition == CirclePosition.center
                        ? AppConstants.largeAnimationDuration
                        : AppConstants.mediumAnimationDuration;

                return Stack(
                  children: [
                    BlocBuilder<SplashBloc, SplashState>(
                      builder: (context, state) {
                        final scale = state is SplashOnboardingActive ? 0.75 : 1.0;
                        final alignment = state is SplashOnboardingActive 
                            ? const Alignment(0, -0.3)  // Move up when sheet appears
                            : Alignment.center;  // Center by default
                        
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
                      },
                    ),
                    BlocListener<SplashBloc, SplashState>(
                      listener: (context, state) {
                        if (state is SplashOnboardingActive) {
                          _showOnboardingSheet(context);
                        }
                      },
                      child: const SizedBox.shrink(),
                    ),
                    AnimatedPositioned(
                      duration: circleDuration,
                      curve: Curves.linearToEaseOut,
                      top: topCircleTop,
                      right: topCircleRight,
                      child: AnimatedContainer(
                        duration: circleDuration,
                        curve: Curves.linearToEaseOut,
                        width: topCircleSize,
                        height: topCircleSize,
                        decoration: BoxDecoration(
                          color: circlesColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: circleDuration,
                      curve: Curves.linearToEaseOut,
                      bottom: bottomCircleBottom,
                      left: bottomCircleLeft,
                      child: AnimatedContainer(
                        duration: circleDuration,
                        curve: Curves.linearToEaseOut,
                        width: bottomCircleSize,
                        height: bottomCircleSize,
                        decoration: BoxDecoration(
                          color: circlesColor,
                          shape: BoxShape.circle,
                        ),
                      ),
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
}
