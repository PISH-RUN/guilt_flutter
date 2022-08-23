import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/guild/presentation/pages/guild_form_page.dart';
import 'package:guilt_flutter/application/guild/presentation/pages/guild_list_page.dart';
import 'package:guilt_flutter/application/guild/presentation/pages/guild_main_panel.dart';
import 'package:guilt_flutter/authenticate_page.dart';
import 'package:guilt_flutter/features/login/api/login_api.dart';
import 'package:guilt_flutter/features/login/presentation/pages/login_page.dart';
import 'package:guilt_flutter/features/login/presentation/pages/register_page.dart';
import 'package:guilt_flutter/features/profile/presentation/pages/profile_page.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'base_page.dart';

class AppRoutes {
  final routes = [
    QRoute.withChild(
      path: '/guild',
      builderChild: (p0) => p0,
      middleware: [
        AuthGuard(),
      ],
      children: [
        QRoute(
          path: '/dashboard',
          builder: () => AuthenticatedPage(child: GuildMainPanel(child: GuildListPage(), currentIndexBottomNavigation: 1)),
          middleware: [AuthGuard()],
        ),
        QRoute(
          path: '/profile',
          builder: () => AuthenticatedPage(child: GuildMainPanel(child: ProfilePage(), currentIndexBottomNavigation: 0)),
          middleware: [AuthGuard()],
        ),
        QRoute(
          path: '/settings',
          builder: () => AuthenticatedPage(child: GuildMainPanel(child: GuildListPage(), currentIndexBottomNavigation: 2)),
          middleware: [AuthGuard()],
        ),
        QRoute(
          path: '/:guildId((^[0-9]*\$))',
          builder: () => const AuthenticatedPage(child: GuildMainPanel(child: GuildFormPage(), currentIndexBottomNavigation: 1)),
          middleware: [AuthGuard()],
        ),
      ],
    ),
    QRoute(path: '/otp', builder: () => BasePage(child: LoginPage.wrappedRoute())),
    QRoute(path: '/register', builder: () => BasePage(child: RegisterPage.wrappedRoute())),
  ];
}

String redirectPath = '';

class AuthGuard extends QMiddleware {
  @override
  Future<String?> redirectGuard(String path) async {
    // if (!GetIt.instance<LoginApi>().isUserRegistered()) {
    //   redirectPath = path;
    //   return '/register';
    // }
    return null;
  }
}
