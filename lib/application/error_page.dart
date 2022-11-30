import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/app_route.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/widgets/our_button.dart';
import 'package:guilt_flutter/features/login/api/login_api.dart';
import 'package:logger/logger.dart';
import 'package:qlevar_router/qlevar_router.dart';

class ErrorPage extends StatelessWidget {
  final Failure failure;
  final void Function()? tryAgain;

  const ErrorPage({required this.failure, this.tryAgain, Key? key}) : super(key: key);

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
      case FailureType.forbiddenError:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(failure.message, style: defaultTextStyle(context, headline: 4)),
            const SizedBox(height: 36.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: GestureDetector(
                onTap: () async {
                  await GetIt.instance<LoginApi>().signOut();
                  QR.navigator.replaceAll(appMode.initPath);
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: const Offset(1, 1),
                      )
                    ],
                  ),
                  child: Text(
                    "خروج از حساب کاربری",
                    style: defaultTextStyle(context, headline: 4).c(Colors.white),
                  ),
                ),
              ),
            ),
          ],
        );
      case FailureType.noInternet:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(failure.message, style: defaultTextStyle(context, headline: 4)),
            const SizedBox(height: 36.0),
            if (tryAgain != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60.0),
                child: GestureDetector(
                  onTap: () => tryAgain!(),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.rectangle,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).primaryColor.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: const Offset(1, 1),
                        )
                      ],
                    ),
                    child: Text(
                      "تلاش مجدد",
                      style: defaultTextStyle(context, headline: 4).c(Colors.white),
                    ),
                  ),
                ),
              ),
          ],
        );
      default:
        return Text(
          failure.message,
          textAlign: TextAlign.center,
          style: defaultTextStyle(context, headline: 4),
        );
    }
  }
}
