import 'package:flutter/material.dart';
import 'package:guilt_flutter/application/guild/presentation/widgets/bottom_navigation.dart';

class GuildMainPanel extends StatefulWidget {
  final int currentIndexBottomNavigation;
  final Widget child;

  const GuildMainPanel({required this.child, required this.currentIndexBottomNavigation, Key? key}) : super(key: key);

  @override
  _GuildMainPanelState createState() => _GuildMainPanelState();
}

class _GuildMainPanelState extends State<GuildMainPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigation(currentIndexBottomNavigation: widget.currentIndexBottomNavigation),
      body: SafeArea(
        child: widget.child,
      ),
    );
  }
}
