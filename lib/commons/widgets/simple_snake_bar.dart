import 'package:flutter/material.dart';
import 'package:guilt_flutter/commons/text_style.dart';

Future<void> showSnakeBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      content: Text(text, textAlign: TextAlign.center, style: defaultTextStyle(context, headline: 5).c(Colors.white))));
  return Future.value(null);
}
