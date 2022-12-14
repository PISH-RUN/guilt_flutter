import 'package:flutter/services.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/commons/utils.dart' as utils;
import 'package:logger/logger.dart';
import 'package:persian_utils/persian_utils.dart';

class TextFieldConfig {
  static String? validateNationalCode(String? value) {
    Logger().i("info=>4 ");
    if (value == null) return null;
    Logger().i("info=>3 ");
    if (value.isEmpty) return "وارد کردن کد ملی ضروری است";
    Logger().i("info=>2 ");
    if (!utils.validateNationalCode(value)) return "کد ملی نامعتبر نیست";
    Logger().i("info=>1 ");
    return null;
  }

  static String? validateOTP(String? value) {
    if (value == null) return null;
    if (value.isEmpty) return "وارد کردن کد ورود ضروری است";
    if (value.length != ONE_TIME_PASSWORD_LENGTH) return "کد ورود معتبر نمی باشد";
    return null;
  }

  static String? validateFirstName(String? value, String name) {
    if (value == null) return null;
    if (value.isEmpty) return "این فیلد الزامی است";
    if (value.length < 2) return "$name کوتاه است";
    if (value.length > 25) return "$name طولانی است";
    if (utils.hasEnglishCharOrNumber(value)) return "$name حروف غیر فارسی دارد";
    return null;
  }

  static String? validateGuildName(String? value) {
    if (value == null) return null;
    if (value.isEmpty) return "این فیلد الزامی است";
    if (value.length < 2) return "نام صنف کوتاه است";
    if (value.length > 60) return "نام صنف طولانی است";
    if (utils.hasEnglishCharOrNumber(value)) return "نام صنف حروف غیر فارسی دارد";
    return null;
  }

  static String? validateAddress(String? value) {
    if (value == null) return null;
    if (value.isEmpty) return "وارد کردن نشانی ضروری است";
    if (value.length < 6) return "نشانی کوتاه است";
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null) return null;
    if (value.isEmpty) return "وارد کردن شماره موبایل ضروری است";
    if (!utils.validatePhoneNumber(value)) return "شماره موبایل معتبر نمی باشد";
    return null;
  }

  static String? validateOrganName(String? value) {
    if (value == null) return null;
    if (value.isEmpty) return "این فیلد الزامی است";
    if (value.length < 2) return "نام سازمان کوتاه است";
    if (value.length > 60) return "نام سازمان طولانی است";
    if (utils.hasEnglishCharOrNumber(value)) return "نام سازمان حروف غیر فارسی دارد";
    return null;
  }

  static String? validateLastName(String? value, String name) {
    if (value == null) return null;
    if (value.isEmpty) return "این فیلد الزامی است";
    if (value.length < 2) return "$name  کوتاه است";
    if (value.length > 40) return "$name طولانی است";
    if (utils.hasEnglishCharOrNumber(value)) return "$name حروف غیر فارسی دارد";
    return null;
  }

  static String? validatePos(String? value) {
    if (value == null) return null;
    if (value.isEmpty) return 'این فیلد خالی است';
    return null;
  }

  static String? validateSheba(String? value) {
    if (value == null) return null;
    if (value.isEmpty) return 'این فیلد خالی است';
    if (!value.isNumber()) return 'شماره شبا معتبر نمی باشد';
    if (value.length != 24) return 'شماره شبا معتبر نمی باشد';
    return null;
  }

  static List<LengthLimitingTextInputFormatter> inputFormattersNationalCode() => [LengthLimitingTextInputFormatter(10)];

  static List<LengthLimitingTextInputFormatter> inputFormattersOTP() => [LengthLimitingTextInputFormatter(ONE_TIME_PASSWORD_LENGTH)];

  static List<LengthLimitingTextInputFormatter> inputFormattersFirstName() => [LengthLimitingTextInputFormatter(25)];

  static List<LengthLimitingTextInputFormatter> inputFormattersLastName() => [LengthLimitingTextInputFormatter(40)];

  static List<LengthLimitingTextInputFormatter> inputFormattersOrganName() => [LengthLimitingTextInputFormatter(60)];

  static List<LengthLimitingTextInputFormatter> inputFormattersProvinceCode() => [LengthLimitingTextInputFormatter(3)];

  static List<LengthLimitingTextInputFormatter> inputFormattersHomeTelephone() => [LengthLimitingTextInputFormatter(8)];

  static List<LengthLimitingTextInputFormatter> inputFormattersGuildName() => [LengthLimitingTextInputFormatter(60)];

  static List<LengthLimitingTextInputFormatter> inputFormattersShebaCode() => [LengthLimitingTextInputFormatter(24)];

  static List<LengthLimitingTextInputFormatter> inputFormattersEmpty() => [];
}
