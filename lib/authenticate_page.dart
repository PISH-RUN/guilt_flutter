import 'package:flutter/cupertino.dart';
import 'package:guilt_flutter/base_page.dart';

class AuthenticatedPage extends StatelessWidget {
  final Widget child;

  const AuthenticatedPage({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasePage(child: child);
  }
}
