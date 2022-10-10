import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/application/error_page.dart';
import 'package:guilt_flutter/features/psp/presentation/pages/all_guild_list_page.dart';
import 'package:guilt_flutter/features/psp/presentation/pages/follow_up_guilds.dart';
import 'package:guilt_flutter/features/psp/presentation/pages/login_via_user_page.dart';
import 'package:guilt_flutter/features/psp/presentation/pages/psp_form_page.dart';
import 'package:guilt_flutter/features/psp/presentation/pages/psp_panel.dart';
import 'package:guilt_flutter/features/psp/presentation/pages/register_via_user_page.dart';
import 'package:guilt_flutter/features/psp/presentation/pages/sign_up_psp.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'application/faq.dart';
import 'application/guild/presentation/pages/guild_form_page.dart';
import 'application/guild/presentation/pages/guild_list_page.dart';
import 'application/guild/presentation/pages/guild_main_panel.dart';
import 'authenticate_page.dart';
import 'base_page.dart';
import 'commons/failures.dart';
import 'features/login/api/login_api.dart';
import 'features/login/presentation/pages/login_page.dart';
import 'features/login/presentation/pages/register_page.dart';
import 'features/profile/api/profile_api.dart';
import 'features/profile/presentation/pages/profile_page.dart';

class AppRoutes {
  final routes = [
    QRoute.withChild(
      path: '/psp',
      builderChild: (p0) => p0,
      middleware: [],
      children: [
        QRoute(
          path: '/signUp',
          builder: () => SignUpPsp.wrappedRoute(),
          middleware: [],
        ),
        QRoute(
          path: '/guildList',
          builder: () => PspPanel(currentIndexBottomNavigation: 0, child: AllGuildsListPage.wrappedRoute(false)),
          middleware: [AuthGuard()],
        ),
        QRoute(
          path: '/editGuild/:token/:guildId((^[0-9]*\$))',
          builder: () => PspFormPage.wrappedRoute(),
          middleware: [AuthGuard()],
        ),
        QRoute(
          path: '/editUser/:token',
          builder: () => ProfilePage.wrappedRoute(true),
          middleware: [AuthGuard()],
        ),
        QRoute(
          path: '/followGuilds',
          builder: () => PspPanel(currentIndexBottomNavigation: 1, child: FollowUpGuildsListPage.wrappedRoute()),
          middleware: [AuthGuard()],
        ),
        QRoute(
          path: '/personalGuild',
          builder: () => PspPanel(currentIndexBottomNavigation: 2, child: GuildPage.wrappedRoute()),
          middleware: [AuthGuard()],
        ),
        QRoute(
          path: '/register/:phoneNumber((^[0-9]*\$))/:guildId((^[0-9]*\$))',
          builder: () => RegisterViaUserPage.wrappedRoute(),
          middleware: [AuthGuard()],
        ),
        QRoute(
          path: '/otp/:guildId((^[0-9]*\$))',
          builder: () => LoginViaUserPage.wrappedRoute(),
          middleware: [],
        ),
      ],
    ),
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
          path: '/profile',
          builder: () => AuthenticatedPage(child: GuildMainPanel(currentIndexBottomNavigation: 0, child: ProfilePage.wrappedRoute(false))),
          middleware: [AuthGuard()],
        ),
        QRoute(
          path: '/faq',
          builder: () => const AuthenticatedPage(child: GuildMainPanel(currentIndexBottomNavigation: 2, child: Faq())),
          middleware: [AuthGuard()],
        ),
        QRoute(
          path: '/add',
          builder: () => AuthenticatedPage(
              child: appMode == AppMode.psp
                  ? GuildFormPage.wrappedRoute(isAddNew: true)
                  : GuildMainPanel(currentIndexBottomNavigation: 1, child: GuildFormPage.wrappedRoute(isAddNew: true))),
          middleware: [AuthGuard(), QMiddlewareBuilder(canPopFunc: () async => !isDialogOpen)],
        ),
        QRoute(
          path: '/view/:guildUuid',
          builder: () => AuthenticatedPage(
              child: appMode == AppMode.psp
                  ? GuildFormPage.wrappedRoute(isAddNew: false)
                  : GuildMainPanel(currentIndexBottomNavigation: 1, child: GuildFormPage.wrappedRoute(isAddNew: false))),
          middleware: [AuthGuard(), QMiddlewareBuilder(canPopFunc: () async => !isDialogOpen)],
        ),
      ],
    ),
    QRoute(path: '/signIn/profile', builder: () => ProfilePage.wrappedRoute(true), middleware: [AuthGuard()]),
    QRoute(path: '/error', builder: () => BasePage(child: ErrorPage(failure: Failure('بروز خطای ناشناخته')))),
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
    final response = await GetIt.instance<ProfileApi>().hasProfile(nationalCode: GetIt.instance<LoginApi>().getUserData().nationalCode);
    return response.fold(
      (l) => l.failureType == FailureType.authentication ? '/register' : '/error',
      (hasProfile) => hasProfile ? null : '/signIn/profile',
    );
  }
}
