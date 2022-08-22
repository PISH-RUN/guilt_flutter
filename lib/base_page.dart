import 'package:flutter/cupertino.dart';

class BasePage extends StatelessWidget {
  final Widget child;

  BasePage({required this.child, Key? key}) : super(key: key);

  bool isApplicationSuggestPanelClosed = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
      ],
    );
  }
}
