import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:guilt_flutter/app_route.dart';
import 'package:guilt_flutter/application/check_something_before_open_app.dart';
import 'package:guilt_flutter/application/light_theme.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'features/login/login_injection_container.dart' as di_login;

void main() async {
  await GetStorage.init();
  HttpOverrides.global = MyHttpOverrides();
  await checkSomethingBeforeOpenApp();
  di_login.init();
  // await setupFcm();//todo
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'guild',
      theme: lightThemeData(),
      debugShowCheckedModeBanner: false,
      routeInformationParser: const QRouteInformationParser(),
      builder: (context, child) => child == null ? const SizedBox() : Directionality(textDirection: TextDirection.rtl, child: child),
      routerDelegate: QRouterDelegate(AppRoutes().routes, withWebBar: false,initPath: 'guild/dashboard'),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
