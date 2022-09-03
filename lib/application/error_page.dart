import 'package:flutter/material.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:qlevar_router/qlevar_router.dart';

class ErrorPage extends StatelessWidget {
  final Failure failure;

  const ErrorPage({required this.failure, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Text(
          "${failure.message}\n${QR.currentPath}",
          textAlign: TextAlign.center,
          style: defaultTextStyle(context, headline: 4),
        ),
      )),
    );
  }
}
