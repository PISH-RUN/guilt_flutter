import 'package:flutter/material.dart';

extension OurText on TextStyle {
  TextStyle s(double h) {
    return copyWith(fontSize: h);
  }

  TextStyle c(Color color) {
    return copyWith(color: color);
  }

  TextStyle h(double height) {
    return copyWith(height: height);
  }

  TextStyle f(String fontFamily) {
    return copyWith(fontFamily: fontFamily);
  }

  TextStyle w(FontWeight fontWeight) {
    return copyWith(fontWeight: fontWeight);
  }
}

TextStyle defaultTextStyle(BuildContext context, {int headline = 4}) {
  switch (headline) {
    case 1:
      return Theme.of(context).textTheme.headline1!;
    case 2:
      return Theme.of(context).textTheme.headline2!;
    case 3:
      return Theme.of(context).textTheme.headline3!;
    case 4:
      return Theme.of(context).textTheme.headline4!;
    case 5:
      return Theme.of(context).textTheme.headline5!;
    case 6:
      return Theme.of(context).textTheme.headline6!;
  }
  return Theme.of(context).textTheme.headline4!;
}
