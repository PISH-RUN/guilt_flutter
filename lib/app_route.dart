import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/faq.dart';
import 'package:guilt_flutter/application/guild/presentation/pages/guild_form_page.dart';
import 'package:guilt_flutter/application/guild/presentation/pages/guild_list_page.dart';
import 'package:guilt_flutter/application/guild/presentation/pages/guild_main_panel.dart';
import 'package:guilt_flutter/authenticate_page.dart';
import 'package:guilt_flutter/features/login/api/login_api.dart';
import 'package:guilt_flutter/features/login/presentation/pages/login_page.dart';
import 'package:guilt_flutter/features/login/presentation/pages/register_page.dart';
import 'package:guilt_flutter/features/profile/api/profile_api.dart';
import 'package:guilt_flutter/features/profile/presentation/pages/profile_page.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'base_page.dart';

class AppRoutes {
  final routes = [
    QRoute.withChild(
      path: '/guild',
      builderChild: (p0) => p0,
      middleware: [AuthGuard(), ProfileGuard(), QMiddlewareBuilder(canPopFunc: () async => !isDialogOpen)],
      children: [
        QRoute(
          path: '/dashboard',
          builder: () => AuthenticatedPage(child: GuildMainPanel(currentIndexBottomNavigation: 1, child: GuildPage.wrappedRoute())),
          middleware: [AuthGuard()],
        ),
        QRoute(
          path: '/profile/:nationalCode((^[0-9]*\$))',
          builder: () => AuthenticatedPage(child: GuildMainPanel(currentIndexBottomNavigation: 0, child: ProfilePage.wrappedRoute())),
          middleware: [AuthGuard()],
        ),
        QRoute(
          path: '/signIn/profile/:nationalCode((^[0-9]*\$))',
          builder: () => ProfilePage.wrappedRoute(),
          middleware: [AuthGuard()],
        ),
        QRoute(
          path: '/faq',
          builder: () => const AuthenticatedPage(child: GuildMainPanel(currentIndexBottomNavigation: 2, child: Faq())),
          middleware: [AuthGuard()],
        ),
        QRoute(
          path: '/add',
          builder: () => AuthenticatedPage(child: GuildMainPanel(currentIndexBottomNavigation: 1, child: GuildFormPage.wrappedRoute(isAddNew: true))),
          middleware: [AuthGuard(), QMiddlewareBuilder(canPopFunc: () async => !isDialogOpen)],
        ),
        QRoute(
          path: '/:guildId((^[0-9]*\$))',
          builder: () =>
              AuthenticatedPage(child: GuildMainPanel(currentIndexBottomNavigation: 1, child: GuildFormPage.wrappedRoute(isAddNew: false))),
          middleware: [AuthGuard(), QMiddlewareBuilder(canPopFunc: () async => !isDialogOpen)],
        ),
      ],
    ),
    QRoute(path: '/error', builder: () => BasePage(child: LoginPage.wrappedRoute())),
    QRoute(path: '/otp', builder: () => BasePage(child: LoginPage.wrappedRoute())),
    QRoute(path: '/register', builder: () => BasePage(child: RegisterPage.wrappedRoute())),
  ];
}

String redirectPath = '';

class AuthGuard extends QMiddleware {
  @override
  Future<String?> redirectGuard(String path) async {
    if (!GetIt.instance<LoginApi>().isUserRegistered()) {
      redirectPath = path;
      return '/register';
    }
    return null;
  }
}

class ProfileGuard extends QMiddleware {
  @override
  Future<String?> redirectGuard(String path) async {
    final nationalCode = QR.params['nationalCode'].toString();
    final response = await GetIt.instance<ProfileApi>().hasProfile(nationalCode: nationalCode);
    return response.fold(
      (l) => '/error',
      (hasProfile) => hasProfile ? null : '/signIn/profile/$nationalCode',
    );
  }
}
