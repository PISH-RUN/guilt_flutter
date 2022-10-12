import 'package:flutter/material.dart';
import 'package:guilt_flutter/commons/text_style.dart';

class IconNameWidget extends StatelessWidget {
  const IconNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage('images/logo.png'),height: 60,width: 60),
            const SizedBox(width: 10.0),
            Text(
              "مدیریت اصناف",
              style: defaultTextStyle(context, headline: 1),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        Text(
          "به شبکه مدیریت اصناف کشور خوش آمدید",
          style: defaultTextStyle(context, headline: 4).c(Colors.black.withOpacity(0.45)),
        ),
      ],
    );
  }
}
