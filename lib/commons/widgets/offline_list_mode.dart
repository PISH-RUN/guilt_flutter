import 'package:flutter/cupertino.dart';

class OfflineListMode extends StatefulWidget {
  final  variable;
  final Widget errorWidget;
  final Widget loadingWidget;
  final Widget emptyWidget;
  final Widget loadedWidget;

  const OfflineListMode({required this.variable, Key? key}) : super(key: key);

  @override
  _OfflineListModeState createState() => _OfflineListModeState();
}

class _OfflineListModeState extends State<OfflineListMode> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
