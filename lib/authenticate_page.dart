import 'package:flutter/cupertino.dart';
import 'package:guilt_flutter/base_page.dart';

class AuthenticatedPage extends StatelessWidget {
  final Widget child;

  const AuthenticatedPage({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //todo set listener for check login and if not redirect to login page
    return BasePage(child: child);
  }
}
