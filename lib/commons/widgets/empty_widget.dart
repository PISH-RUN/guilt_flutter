import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/utils.dart';

class EmptyWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final String buttonText;
  final void Function() onPressed;

  const EmptyWidget({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.buttonText,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const Spacer(flex: 60),
          SmartImage(imagePath: imagePath, width: 180, height: 180),
          const Spacer(flex: 30),
          Text(title, textAlign: TextAlign.center, style: defaultTextStyle(context, headline: 4)),
          const SizedBox(height: 18.0),
          Text(description, textAlign: TextAlign.center, style: defaultTextStyle(context, headline: 5).c(Colors.grey)),
          const Spacer(flex: 16),
          GestureDetector(
            onTap: () => onPressed(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                boxShadow: simpleShadow(color: Theme.of(context).primaryColor),
              ),
              child: Text(
                buttonText,
                textAlign: TextAlign.center,
                style: defaultTextStyle(context, headline: 4).c(Colors.white),
              ),
            ),
          ),
          const Spacer(flex: 60),
        ],
      ),
    );
  }
}

class SmartImage extends StatelessWidget {
  final String imagePath;
  final double? height;
  final double? width;

  const SmartImage({required this.imagePath, this.height, this.width, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imagePath.endsWith('.svg')) return SvgPicture.asset(imagePath, height: height, width: width, fit: BoxFit.contain);
    // if (imagePath.endsWith('.json')) return Lottie.asset(imagePath, width: width, height: height, fit: BoxFit.contain);
    if (isUrlValid(imagePath)) return Image(image: NetworkImage(imagePath), height: height, width: width, fit: BoxFit.contain);
    return Image(image: AssetImage(imagePath), height: height, width: width, fit: BoxFit.contain);
  }
}
