import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/application/guild/domain/entities/icis.dart';
import 'package:guilt_flutter/application/isic.dart';
import 'package:http/http.dart';
import 'package:persian_utils/persian_utils.dart';
import 'package:shamsi_date/shamsi_date.dart';

bool isSuccessfulHttp(Response response) {
  return isSuccessfulStatusCode(response.statusCode);
}

String extractNumberInLargeText(String message, int numberOFDigit) {
  final regexp = RegExp(List.generate(numberOFDigit, (index) => "[0-9]").join(""));
  final match = regexp.firstMatch(message);
  final matchedText = match?.group(0);
  return matchedText ?? "";
}

void unFocus(BuildContext context) {
  final currentFocus = FocusScope.of(context);
  currentFocus.unfocus();
}

List<BoxShadow> simpleShadow({Color color = Colors.grey}) {
  return [
    BoxShadow(
      color: color.withOpacity(0.3),
      spreadRadius: 2,
      blurRadius: 7,
      offset: const Offset(2, 2),
    )
  ];
}

bool isWebPlatform() => kIsWeb;

bool isSuccessfulStatusCode(int statusCode) {
  return statusCode >= 200 && statusCode <= 300;
}

Future<bool> isInternetEnable() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  return connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi;
}

void closeKeyboard() async {
  FocusManager.instance.primaryFocus?.unfocus();
}

bool validateNationalCode(String nationalCode) {
  if (nationalCode.length != 10) return false;
  final array = nationalCode.split('');
  int sum = 0;
  for (int i = 0; i < 9; i++) {
    sum += int.parse(array[i]) * (10 - i);
  }
  int mod = sum % 11;
  int controlNum = mod >= 2 ? 11 - mod : mod;
  return controlNum.toString() == array[9];
}





String replaceFarsiNumber(String input) {
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const farsi = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
  for (int i = 0; i < english.length; i++) {
    input = input.replaceAll(farsi[i], english[i]);
  }
  return input;
}

bool hasEnglishCharOrNumber(String input) {
  final array = input.split('');
  for (int i = 0; i < array.length; i++) {
    if (RegExp(r'^[A-Za-z0-9_.]+$').hasMatch(array[i].toString())) return true;
  }
  return false;
}













String? getPhoneNumber(String phoneNumber) {
  phoneNumber = replaceFarsiNumber(phoneNumber.trim().replaceAll(" ", ""));
  phoneNumber = phoneNumber.replaceAll("+", "");
  if (!phoneNumber.isNumber()) return null;
  if (phoneNumber.length < 10) return null;
  if (phoneNumber.length == 10) return phoneNumber;
  if (phoneNumber.length == 11 && phoneNumber.startsWith("0")) return phoneNumber.substring(1);
  if (phoneNumber.length == 12 && phoneNumber.startsWith("98")) return phoneNumber.substring(2);
  if (phoneNumber.length == 13 && phoneNumber.startsWith("980")) return phoneNumber.substring(3);
  if (phoneNumber.length == 14 && phoneNumber.startsWith("9898")) return phoneNumber.substring(4);
  return null;
}

String niceShowPhoneNumber(String phoneNumber) {
  String phone = getPhoneNumber(phoneNumber) ?? "";
  if (phone.isEmpty) {
    return "";
  }
  String output = "";
  for (int i = 0; i < phone.length; i++) {
    if (i == 3 || i == 6) {
      output += "  ${phone[i]}";
    } else {
      output += phone[i];
    }
  }
  return output;
}

String getFirstWordsOfOneSentence(String input, int numberOfWords, {bool has3Dots = false}) {
  final output = input.split(' ').sublist(0, min(input.split(' ').length, numberOfWords)).join(' ');
  return has3Dots && input.split(' ').length > numberOfWords ? "$output ..." : output;
}

String extractIdFromUrl(String value) {
  String localValue = value;
  if (localValue.contains('/')) {
    localValue = localValue.substring(localValue.lastIndexOf('/') + 1);
  }
  if (localValue.contains("?")) {
    localValue = localValue.substring(0, localValue.indexOf("?"));
  }
  return localValue;
}

bool isEmailValid(String mail) {
  return RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(mail);
}

bool isFlutterWebRunOnAndroid() {
  return kIsWeb && defaultTargetPlatform == TargetPlatform.android;
}

bool validatePhoneNumber(String phoneNumber) {
  return getPhoneNumber(phoneNumber) != null && getPhoneNumber(phoneNumber)!.startsWith("9");
}

String convertTextToHtmlText(String plainText) {
  return "<div dir=\"rtl\">$plainText&nbsp;</div> ".replaceAll("\n", "</br>");
}

bool isTextHtml(String text) {
  return text.startsWith("<");
}

bool isFlutterWebRunOnDesktop() {
  return kIsWeb && (defaultTargetPlatform != TargetPlatform.iOS && defaultTargetPlatform != TargetPlatform.android);
}

TargetPlatform getDefaultTargetPlatform() {
  return defaultTargetPlatform;
}

bool isRunInAndroid() {
  return defaultTargetPlatform == TargetPlatform.android || Platform.isAndroid;
}

bool isRunInIOS() {
  return defaultTargetPlatform == TargetPlatform.iOS || Platform.isIOS;
}

String persianToLowerCase(String input) {
  String output = input.replaceAll("آ", "ا");
  return output;
}

String convertJsonItemToString(Map<String, dynamic> json, String key, {String defaultValue = ""}) {
  return convertDynamicToString(json[key]);
}

String convertDynamicToString(dynamic item, {String defaultValue = ""}) {
  try {
    return (item ?? defaultValue).toString().trim();
  } on Exception {
    return defaultValue;
  }
}

int convertDynamicToInt(dynamic item, {int defaultValue = 0}) {
  return int.parse(convertDynamicToString(item, defaultValue: defaultValue.toString()));
}

bool convertDynamicToBool(dynamic item, {bool defaultValue = false}) {
  final output = convertDynamicToString(item, defaultValue: defaultValue.toString());
  return output == "1" || output == "true";
}

bool isUrlValid(String url) {
  try {
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  } on Exception {
    return false;
  }
}

String persianToUpperCase(String input) {
  String output = input.replaceAll("ا", "آ");
  return output;
}

String convertSecondToTimeFormat(int seconds) {
  var d = Duration(days: 0, hours: 0, minutes: 0, seconds: seconds, microseconds: 0);
  String fullTime = d.toString().split('.').first.padLeft(8, "0");
  if (d.inHours > 0)
    return fullTime;
  else
    return fullTime.substring(3);
}

String _dateSplitter = "/";

String convertJalaliToString(Jalali input) {
  final inputFormatter = input.formatter;
  return "${inputFormatter.yyyy}$_dateSplitter${inputFormatter.mm}$_dateSplitter${inputFormatter.dd}";
}

Jalali convertStringToJalali(String input) {
  String splitter = input.contains("-") ? "-" : "/";
  return Jalali(int.parse(input.split(splitter)[0]), int.parse(input.split(splitter)[1]), int.parse(input.split(splitter)[2]));
}

String convertGregorianToString(Gregorian input) {
  final inputFormatter = input.formatter;
  return "${inputFormatter.yyyy}$_dateSplitter${inputFormatter.mm}$_dateSplitter${inputFormatter.dd}";
}

Gregorian convertStringToGregorian(String input) {
  String splitter = input.contains("-") ? "-" : "/";
  return Gregorian(int.parse(input.split(splitter)[0]), int.parse(input.split(splitter)[1]), int.parse(input.split(splitter)[2]));
}

Gregorian convertJalaliToGregorian(Jalali input) {
  return Gregorian.fromJalali(input);
}

Jalali convertGregorianToJalali(Gregorian input) {
  return Jalali.fromGregorian(input);
}

int _lastTimerCall = 0;

void timerAction({required Function startAction, required Function endAction, required int milliSecondWait, int? rightNow}) async {
  int localRightNow = rightNow ?? DateTime.now().millisecondsSinceEpoch;
  _lastTimerCall = localRightNow;
  startAction();
  await Future.delayed(Duration(milliseconds: milliSecondWait), () => "1");
  if (localRightNow == _lastTimerCall) endAction();
}

Future<String> getDeviceName() async {
  try {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (isWebPlatform()) {
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      return webBrowserInfo.userAgent ?? "unknown browser";
    } else {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return "${androidInfo.model} (${androidInfo.version.sdkInt})";
    }
  } on Exception {
    return "can not get device name";
  }
}

dynamic jsonFiledParserDynamic(Map<String, dynamic> json, List<String> filedNames) {
  dynamic innerJson = json;
  for (int i = 0; i < filedNames.length; i++) {
    if (innerJson[filedNames[i]] == null) {
      return null;
    }
    innerJson = innerJson[filedNames[i]];
  }
  return innerJson;
}

String jsonFiledParserString(Map<String, dynamic> json, List<String> filedNames) {
  final result = jsonFiledParserDynamic(json, filedNames);
  return result == null ? "" : result.toString().trim();
}

int? jsonFiledParserInt(Map<String, dynamic> json, List<String> filedNames) {
  final result = jsonFiledParserString(json, filedNames);
  return result.isEmpty ? null : int.parse(result);
}

bool jsonFiledParserBool(Map<String, dynamic> json, List<String> filedNames) {
  final result = jsonFiledParserString(json, filedNames).toLowerCase();
  return result.isEmpty ? false : result == "1" || result == "true";
}

List<Isic> _isicList = [];

void initialListOfIsic() {
  final output = isicListJson.map<Isic>((e) => Isic(name: e["ISICName"].toString().trim(), code: e["isicCoding"].toString().trim())).toList();
  _isicList = output;
}

List<Isic> getListOfIsic() {
  if (_isicList.isEmpty) {
    initialListOfIsic();
  }
  return _isicList;
}

Isic getIsicWithCode(String code) {
  if (_isicList.isEmpty) {
    initialListOfIsic();
  }
  return _isicList.firstWhereOrNull((element) => element.code == code) ?? _isicList[0];
}

Isic getIsicWithName(String name) {
  if (_isicList.isEmpty) {
    initialListOfIsic();
  }
  return _isicList.firstWhere((element) => element.name == name);
}

Future<List<String>> getIranProvince(BuildContext context) async {
  String data = await DefaultAssetBundle.of(context).loadString("jsons/iran.json");
  final jsonResult = jsonDecode(data) as List;
  final output = jsonResult.map<String>((e) => e["province_name"].toString().trim()).toList().toSet().toList();
  output.sort();
  int tehranIndex = output.indexOf("تهران");
  if (tehranIndex >= 0) {
    output.remove("تهران");
    output.insert(0, "تهران");
  }
  return output;
}

Future<List<String>> getCitiesOfOneProvince(BuildContext context, String provinceName) async {
  String data = await DefaultAssetBundle.of(context).loadString("jsons/iran.json");
  final jsonResult = jsonDecode(data) as List;
  final output = jsonResult
      .where((element) => provinceName.isEmpty ? true : element["province_name"].toString().trim() == provinceName.trim())
      .toList()
      .map<String>((e) => e["city_name"])
      .toList();
  output.sort();
  int tehranIndex = output.indexOf("تهران");
  if (tehranIndex >= 0) {
    output.remove("تهران");
    output.insert(0, "تهران");
  }
  return output;
}

Future<String> getProvinceOfOneCity(BuildContext context, String cityName) async {
  String data = await DefaultAssetBundle.of(context).loadString("jsons/iran.json");
  final jsonResult = jsonDecode(data) as List;
  return jsonResult.firstWhere((element) => element["city_name"].toString().trim() == cityName)["province_name"].toString().trim();
}

extension NewProperty on Duration {
  int days() {
    String output = toString();
    output = output.substring(0, output.indexOf('.'));
    List<String> times = output.split(':');
    return int.parse(times[0]) ~/ 24;
  }

  int hour() {
    String output = toString();
    output = output.substring(0, output.indexOf('.'));
    List<String> times = output.split(':');
    return int.parse(times[0]) % 24;
  }

  int minute() {
    String output = toString();
    output = output.substring(0, output.indexOf('.'));
    List<String> times = output.split(':');
    return int.parse(times[1]);
  }

  int second() {
    String output = toString();
    output = output.substring(0, output.indexOf('.'));
    List<String> times = output.split(':');
    return int.parse(times[2]);
  }
}
