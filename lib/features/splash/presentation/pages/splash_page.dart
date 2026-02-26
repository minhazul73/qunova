import 'package:flutter/material.dart';
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
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  void _showOnboardingSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      transitionAnimationController: _sheetController,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
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
        if (state is SplashOnboardingActive) {
          _showOnboardingSheet(context);
        } else if (state is SplashReadyToNavigate) {
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

                final smallCircleRadius = width * .2;
                final largeCircleRadius = width * .3;
                final loaderRadius = width * .05;

                // Calculate positions based on state
                double smallCircleBottom;
                double smallCircleLeft;
                double smallCircleSize;

                double largeCircleTop;
                double largeCircleRight;
                double largeCircleSize;

                Color circlesColor;

                switch (state.circlePosition) {
                  case CirclePosition.hidden:
                    // Fully off-screen
                    smallCircleBottom = -smallCircleRadius * 2;
                    smallCircleLeft = -smallCircleRadius * 2;
                    smallCircleSize = smallCircleRadius * 2;

                    largeCircleTop = -largeCircleRadius * 2;
                    largeCircleRight = -largeCircleRadius * 2;
                    largeCircleSize = largeCircleRadius * 2;
                    break;

                  case CirclePosition.corners:
                    // Partially visible in corners
                    smallCircleBottom = -smallCircleRadius;
                    smallCircleLeft = -smallCircleRadius;
                    smallCircleSize = smallCircleRadius * 2;

                    largeCircleTop = -largeCircleRadius;
                    largeCircleRight = -largeCircleRadius;
                    largeCircleSize = largeCircleRadius * 2;
                    break;

                  case CirclePosition.center:
                    // Moving to center with size changes
                    if (state.isAnimatingFinal) {
                      // Small circle shrinks to loader size at center
                      smallCircleBottom = height / 2 - loaderRadius;
                      smallCircleLeft = width / 2 - loaderRadius;
                      smallCircleSize = loaderRadius * 2;

                      // Large circle expands to cover screen from center
                      final maxDimension = width > height ? width : height;
                      final expandedSize = maxDimension * 1.5;
                      largeCircleTop = height / 2 - expandedSize / 2;
                      largeCircleRight = width / 2 - expandedSize / 2;
                      largeCircleSize = expandedSize;
                    } else {
                      // Default center positions
                      smallCircleBottom = height / 2 - smallCircleRadius;
                      smallCircleLeft = width / 2 - smallCircleRadius;
                      smallCircleSize = smallCircleRadius * 2;

                      largeCircleTop = height / 2 - largeCircleRadius;
                      largeCircleRight = width / 2 - largeCircleRadius;
                      largeCircleSize = largeCircleRadius * 2;
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
                    Center(
                      child: Image.asset(
                        AppConstants.appBrand,
                      ),
                    ),
                    AnimatedPositioned(
                      duration: circleDuration,
                      curve: Curves.linearToEaseOut,
                      top: largeCircleTop,
                      right: largeCircleRight,
                      child: AnimatedContainer(
                        duration: circleDuration,
                        curve: Curves.linearToEaseOut,
                        width: largeCircleSize,
                        height: largeCircleSize,
                        decoration: BoxDecoration(
                          color: circlesColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: circleDuration,
                      curve: Curves.linearToEaseOut,
                      bottom: smallCircleBottom,
                      left: smallCircleLeft,
                      child: AnimatedContainer(
                        duration: circleDuration,
                        curve: Curves.linearToEaseOut,
                        width: smallCircleSize,
                        height: smallCircleSize,
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
