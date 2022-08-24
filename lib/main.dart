import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:guilt_flutter/app_route.dart';
import 'package:guilt_flutter/application/check_something_before_open_app.dart';
import 'package:guilt_flutter/application/light_theme.dart';
import 'package:guilt_flutter/commons/data/data_source/remote_data_source.dart';
import 'package:guilt_flutter/commons/data/data_source/remote_data_source_impl.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'package:http/http.dart' as http;

import 'package:mapir_raster/mapir_raster.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'features/login/login_injection_container.dart' as di_login;
import 'features/profile/profile_injection_container.dart' as di_profile;
import 'application/guild/guild_injection_container.dart' as di_guild;

void main() async {
  await GetStorage.init();
  prepareGetIt();
  HttpOverrides.global = MyHttpOverrides();
  await checkSomethingBeforeOpenApp();
  runApp(MyApp());
}

void prepareGetIt() {
  GetIt.instance.registerSingleton<RemoteDataSource>(RemoteDataSourceImpl(
    client: http.Client(),
    isInternetEnable: isInternetEnable,
    readDataFromLocal: (key) => GetStorage().read<String>(key) ?? '',
    writeDataToLocal: GetStorage().write,
  ));
  di_login.init();
  di_profile.init();
  di_guild.init();
}

const String initPath = 'guild/dashboard';

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'guild',
      theme: lightThemeData(),
      debugShowCheckedModeBanner: false,
      routeInformationParser: const QRouteInformationParser(),
      builder: (context, child) => child == null ? const SizedBox() : Directionality(textDirection: TextDirection.rtl, child: child),
      routerDelegate: QRouterDelegate(AppRoutes().routes, withWebBar: false, initPath: initPath),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
