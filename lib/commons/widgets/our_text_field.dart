import 'package:flutter/material.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/widgets/text_form_field_wrapper.dart';

class OurTextField extends StatelessWidget {
  final String title;
  final TextFormField textFormField;

  const OurTextField({required this.title, required this.textFormField, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 6.0),
          child: Text(title, style: defaultTextStyle(context, headline: 5)),
        ),
        const SizedBox(height: 6.0),
        textFormField,
      ],
    );
  }
}
