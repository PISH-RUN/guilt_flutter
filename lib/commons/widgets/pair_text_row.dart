import 'package:flutter/material.dart';
import 'package:guilt_flutter/commons/text_style.dart';

class PairTextRow extends StatelessWidget {
  final String title;
  final String value;

  const PairTextRow({required this.title, required this.value, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("$title:", style: defaultTextStyle(context, headline: 4).c(Colors.black54).w(FontWeight.w300)),
        const SizedBox(width: 8.0),
        Text(value, style: defaultTextStyle(context, headline: 4).w(FontWeight.w500)),
      ],
    );
  }
}
