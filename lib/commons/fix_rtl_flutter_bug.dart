import 'package:flutter/material.dart';

void fixRtlFlutterBug(TextEditingController controller) {
  if (controller.selection == TextSelection.fromPosition(TextPosition(offset: controller.text.length - 1))) {
    controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
  } else if (controller.text.endsWith('لا') && controller.selection == TextSelection.fromPosition(TextPosition(offset: controller.text.length - 2))) {
    controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
  }
}
