import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/features/login/api/login_api.dart';
import 'package:qlevar_router/qlevar_router.dart';

class ForbiddenPage extends StatelessWidget {
  const ForbiddenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: Center(child: errorStyle(context))));
  }

  Widget errorStyle(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(appMode.forbiddenError, style: defaultTextStyle(context, headline: 4)),
        const SizedBox(height: 46.0),
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
  }
}
