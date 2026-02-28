import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/contacts/domain/entities/contact_entity.dart';
import '../../features/contacts/presentation/pages/contact_detail_page.dart';
import '../../features/contacts/presentation/pages/contacts_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import 'route_names.dart';

final navigatorKey = GlobalKey<NavigatorState>();

GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: RouteNames.root,
  routes: <GoRoute>[
    GoRoute(
      path: RouteNames.root,
      name: SplashPage.name,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: RouteNames.contactsPath,
      name: ContactsPage.name,
      builder: (context, state) => const ContactsPage(),
    ),
    GoRoute(
      path: RouteNames.contactDetailPath,
      name: ContactDetailPage.name,
      builder: (context, state) {
        final contact = state.extra as ContactEntity;
        return ContactDetailPage(contact: contact);
      },
    ),
  ],
);
