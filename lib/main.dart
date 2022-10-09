import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:guilt_flutter/app_route.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/application/light_theme.dart';
import 'package:guilt_flutter/commons/data/data_source/remote_data_source.dart';
import 'package:guilt_flutter/commons/data/data_source/remote_data_source_impl.dart';
import 'package:guilt_flutter/commons/data/model/json_parser.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'package:guilt_flutter/features/login/api/login_api.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'application/guild/guild_injection_container.dart' as di_guild;
import 'features/login/login_injection_container.dart' as di_login;
import 'features/profile/profile_injection_container.dart' as di_profile;
import 'features/psp/psp_injection_container.dart' as di_psp;

String provincePsp = '';

void main() async {
  await GetStorage.init();
  prepareGetIt();
  HttpOverrides.global = MyHttpOverrides();
  await getProvinceOfPsp();
  runApp(MyApp());
}

String province = "تهران";

Future<void> getProvinceOfPsp() async {
  if ((!GetIt.instance<LoginApi>().isUserRegistered()) || appMode != AppMode.psp) return;
  await GetIt.instance<RemoteDataSource>().getFromServer(
    url: '${BASE_URL_API}users/psps',
    params: {},
    mapSuccess: (Map<String, dynamic> json) {
      province = JsonParser.stringParser(json, ['data', 'province']);
    },
  );
}

void prepareGetIt() {
  GetIt.instance.registerSingleton<RemoteDataSource>(RemoteDataSourceImpl(
    client: http.Client(),
    isInternetEnable: isInternetEnable,
    readDataFromLocal: (key) => GetStorage().read<String>(key) ?? '',
    writeDataToLocal: GetStorage().write,
  ));
  di_login.init();
  di_guild.init();
  di_profile.init();
  if (appMode == AppMode.psp) {
    di_psp.init();
  }
}

String initPath = 'guild/dashboard';

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'guild',
      theme: lightThemeData(),
      debugShowCheckedModeBanner: false,
      routeInformationParser: const QRouteInformationParser(),
      builder: (context, child) => child == null ? const SizedBox() : SafeArea(child: Directionality(textDirection: TextDirection.rtl, child: child)),
      routerDelegate: QRouterDelegate(AppRoutes().routes, withWebBar: true, initPath: appMode.initPath),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
