import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/contacts/presentation/bloc/contacts_bloc.dart';
import 'features/splash/presentation/bloc/splash_bloc.dart';
import 'injection.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<SplashBloc>()),
        BlocProvider(create: (_) => sl<ContactsBloc>()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          return MaterialApp.router(
            title: 'Qunova',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightForWidth(constraints.maxWidth),
            routerConfig: router,
          );
        },
      ),
    );
  }
}
