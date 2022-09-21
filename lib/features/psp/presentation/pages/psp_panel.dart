import 'package:flutter/material.dart';
import 'package:guilt_flutter/features/psp/presentation/widgets/bottom_navigation_psp.dart';

class PspPanel extends StatelessWidget {
  final int currentIndexBottomNavigation;
  final Widget child;

  const PspPanel({required this.child, required this.currentIndexBottomNavigation, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationPsp(currentIndexBottomNavigation: currentIndexBottomNavigation),
    );
  }
}
