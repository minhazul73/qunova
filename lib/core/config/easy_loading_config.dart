import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../constants/app_constants.dart';
import '../widgets/breathing_circle_loader.dart';

void configEasyLoading(BuildContext context) {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Colors.transparent
    ..boxShadow = const <BoxShadow>[]
    ..indicatorColor = Colors.white
    ..progressColor = Colors.white
    ..textColor = Colors.white
    ..textStyle = const TextStyle(
      fontSize: 16.0,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    )
    ..dismissOnTap = false
    ..userInteractions = false
    ..maskType = EasyLoadingMaskType.custom
    ..maskColor = Colors.black.withValues(alpha: 0.2)
    ..indicatorWidget = const BreathingCircleLoader(
      imagePath: AppConstants.appLogo,
      size: AppConstants.loaderSize,
      borderRadius: AppConstants.loaderBorderRadius,
    )
    ..animationStyle = EasyLoadingAnimationStyle.opacity
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle;
}
