import 'package:flutter/material.dart';
import 'package:guilt_flutter/application/colors.dart';

ThemeData lightThemeData() {
  return ThemeData(
    primaryColor: AppColor.blue,
    fontFamily: 'iranSans',
    elevatedButtonTheme: ElevatedButtonThemeData(style: getElevatedButtonStyle(AppColor.blue)),
    outlinedButtonTheme: OutlinedButtonThemeData(style: getOutlinedButtonStyle(AppColor.blue)),
    scaffoldBackgroundColor: AppColor.blueGrey,
    textTheme: const TextTheme(
      headline1: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
      headline2: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
      headline3: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
      headline4: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
      headline5: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black),
      headline6: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.black),
    ),
    iconTheme: const IconThemeData(color: AppColor.blue, size: 23.0),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.black87),
    inputDecorationTheme: const InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(width: 2, color: AppColor.blue),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(width: 1.2, color: Color(0xd9848484)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(width: 1.5, color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(width: 2, color: Colors.red),
      ),
      labelStyle: TextStyle(fontSize: 16.0, color: Colors.grey),
      errorStyle: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.red),
      helperStyle: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.grey),
      contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
    ),
    cardTheme: const CardTheme(
      shadowColor: Color(0xff8899f8),
      elevation: 17,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
    ),
  );
}

ButtonStyle getOutlinedButtonStyle(Color color) {
  return OutlinedButton.styleFrom(
      primary: color,
      side: BorderSide(color: color, width: 2),
      textStyle: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'iranSans'));
}

ButtonStyle getElevatedButtonStyle(Color color) {
  return ElevatedButton.styleFrom(
    primary: color,
    textStyle: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'iranSans'),
  );
}
