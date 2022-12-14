import 'package:flutter/material.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'package:guilt_flutter/commons/widgets/loading_widget.dart';

class OurButton extends StatelessWidget {
  final void Function() onTap;
  final bool isLoading;
  final String title;
  final Color? color;

  const OurButton({required this.onTap, required this.title, required this.isLoading, this.color, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isLoading) {
          return;
        }
        onTap();
      },
      child: Container(
        width: double.infinity,
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: color ?? Colors.blue,
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: simpleShadow(color: color ?? Colors.blue)),
        child: isLoading ? LoadingWidget(color: Colors.white, size: 20) : Text(title, style: defaultTextStyle(context, headline: 4).c(Colors.white)),
      ),
    );
  }
}
