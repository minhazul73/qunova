import 'package:flutter/material.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MaterialApp.router(
          title: 'Qunova',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightForWidth(constraints.maxWidth),
          routerConfig: router,
        );
      },
    );
  }
}
