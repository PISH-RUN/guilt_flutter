import 'package:flutter/material.dart';
import 'package:guilt_flutter/app_route.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/widgets/our_button.dart';
import 'package:qlevar_router/qlevar_router.dart';

class ErrorPage extends StatelessWidget {
  final Failure failure;

  const ErrorPage({required this.failure, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: Center(child: errorStyle(context))));
  }

  Widget errorStyle(BuildContext context) {
    switch (failure.failureType) {
      case FailureType.authentication:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(failure.message, style: defaultTextStyle(context, headline: 4)),
            const SizedBox(height: 36.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: OurButton(
                  onTap: () {
                    redirectPath = QR.currentPath;
                    QR.navigator.replaceAll('/register');
                  },
                  title: "ورود",
                  isLoading: false),
            ),
          ],
        );
      default:
        return Text(
          "${failure.message}\n${QR.currentPath}",
          textAlign: TextAlign.center,
          style: defaultTextStyle(context, headline: 4),
        );
    }
  }
}
