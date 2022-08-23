import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';

void main() async {
  generateFeature(const App(
    name: "yekodo",
    description: "app for children",
    primaryColor: "#f4f4f5",
    backgroundColor: "#ffffff",
  ));
}

void createFile(String path, String content) async {
  File file = File(path);
  final isExist = await file.exists();
  if (!isExist) {
    file.createSync(recursive: true);
    file.writeAsString(content);
  }
}

class App extends Equatable {
  final String name;
  final String description;
  final String primaryColor;
  final String backgroundColor;

  const App({
    required this.name,
    required this.description,
    required this.primaryColor,
    required this.backgroundColor,
  });

  @override
  List<Object> get props => [name];
}

void generateFeature(App app) {
  String mainPath = "home/";
  createFile("${mainPath}analysis_options.yaml", parseYamlFile());
  createFile("${mainPath}flutter_native_splash.yaml", parseNativeSplash());
  createFile("${mainPath}web/manifest.json", parseManifestJson(app));
}

String parseYamlFile() {
  String output = "include: package:flutter_lints/flutter.yaml\n\n";
  output += "analyzer:\n";
  output += "  errors:\n";
  output += "    missing_required_param: error\n";
  output += "    override_on_non_overriding_member: error\n";
  output += "    missing_return: error\n";
  output += "    must_be_immutable: ignore\n";
  output += "    constant_identifier_names: ignore\n\n";
  output += "linter:\n";
  output += "  rules:\n";
  output += "    parameter_assignments: false\n";
  output += "    unnecessary_statements: true\n";
  output += "    avoid_print: true\n";
  output += "    sized_box_for_whitespace: true\n";
  output += "    must_be_immutable: false\n";
  output += "    constant_identifier_names: false\n\n";

  return output;
}

String parseNativeSplash() {
  String output = "flutter_native_splash:\n";
  output += "  color: \"#e2f1fd\"\n";
  output += "  image: images/logo_original.png\n";
  output += "  android_12:\n";
  return output;
}

String parseManifestJson(App app) {
  final output = {
    "name": app.name,
    "short_name": app.name,
    "start_url": ".",
    "display": "standalone",
    "background_color": app.backgroundColor,
    "theme_color": app.primaryColor,
    "description": app.description,
    "orientation": "portrait-primary",
    "prefer_related_applications": false,
    "icons": [
      {"src": "icons/Icon-192.png", "sizes": "192x192", "type": "image/png"},
      {"src": "icons/Icon-512.png", "sizes": "512x512", "type": "image/png"},
      {"src": "icons/Icon-maskable-192.png", "sizes": "192x192", "type": "image/png", "purpose": "maskable"},
      {"src": "icons/Icon-maskable-512.png", "sizes": "512x512", "type": "image/png", "purpose": "maskable"}
    ]
  };
  return jsonEncode(output);
}

String parseMainFile() {
  String output = "import 'dart:io';\n";
  output += "import 'package:flutter/material.dart';\n";
  output += "import 'package:flutter/services.dart';\n";
  output += "import 'package:get_storage/get_storage.dart';\n";
  output += "import 'application/texts.dart';\n";
  output += "import 'application/light_theme.dart';\n";
  output += "import 'app_router.dart';\n";
  output += "import 'init_git_it_files.dart';\n";
  output += "import 'import 'package:url_strategy/url_strategy.dart';';\n\n";
  output += "void main() async {\n";
  output += "await GetStorage.init();\n";
  output += "initGetItFiles()\n";
  output += "HttpOverrides.global = MyHttpOverrides();\n";
  output += "setPathUrlStrategy();\n";
  output += "SystemChrome.setPreferredOrientations([\n";
  output += "DeviceOrientation.portraitDown,\n";
  output += "DeviceOrientation.portraitUp,\n";
  output += "]);\n";
  output += "runApp(const MyApp());\n";
  output += "}\n\n";
  output += "class MyApp extends StatelessWidget {\n";
  output += "const MyApp({Key? key}) : super(key: key);\n";
  output += "@override\n";
  output += "Widget build(BuildContext context) {\n";
  output += "return MaterialApp(\n";
  output += " title: Texts.appTitle,\n";
  output += "theme: lightThemeData(),\n";
  output += "builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child!),\n";
  output += "debugShowCheckedModeBanner: false,\n";
  output += "initialRoute: '/',\n";
  output += "routes: routes,\n";
  output += ");\n";
  output += "}\n";
  output += "}\n\n";
  output += "class MyHttpOverrides extends HttpOverrides {\n";
  output += "@override\n";
  output += " HttpClient createHttpClient(SecurityContext? context) {\n";
  output += "return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;\n";
  output += "}\n";
  output += "}\n";

  return output;
}
