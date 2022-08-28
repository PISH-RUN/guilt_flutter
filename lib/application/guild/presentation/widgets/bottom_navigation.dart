import 'package:flutter/material.dart';
import 'package:guilt_flutter/application/colors.dart';
import 'package:guilt_flutter/commons/widgets/simple_snake_bar.dart';
import 'package:guilt_flutter/features/profile/domain/entities/user_info.dart';
import 'package:qlevar_router/qlevar_router.dart';

const double iconSize = 36;
const double paddingSize = 6;

class BottomNavigation extends StatelessWidget {
  final int currentIndexBottomNavigation;
  final bool visible;

  BottomNavigation({
    Key? key,
    required int currentIndexBottomNavigation,
    this.visible = true,
  })  : this.currentIndexBottomNavigation = currentIndexBottomNavigation,
        super(key: key);

  double iconSize = 50.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, -1),
          )
        ],
      ),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, color: AppColor.blue),
            activeIcon: Icon(Icons.person, color: AppColor.blue),
            label: 'پروفایل',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined, color: AppColor.blue),
            activeIcon: Icon(Icons.dashboard, color: AppColor.blue),
            label: 'لیست اصناف',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer_outlined, color: AppColor.blue),
            activeIcon: Icon(Icons.question_answer, color: AppColor.blue),
            label: 'سوالات متداول',
            backgroundColor: Colors.white,
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              if (userInfo.firstName.isEmpty) {
                showSnakeBar(context, 'ابتدا صنف جدید را وارد کنید');
              } else {
                QR.to('/guild/profile');
              }
              return;
            case 1:
              QR.to('/guild/dashboard');
              return;
            case 2:
              QR.to('/guild/faq');
              return;
            default:
              return;
          }
        },
        currentIndex: currentIndexBottomNavigation,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.black,
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 11,
          color: Colors.black,
        ),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: Colors.black,
        ),
        selectedIconTheme: const IconThemeData(color: Colors.black, opacity: 1.0, size: 25),
        unselectedIconTheme: const IconThemeData(color: Colors.black, opacity: 0.4, size: 25),
      ),
    );
  }

  SizedBox disableIconWidget(String imgAddress) =>
      SizedBox(width: iconSize, height: iconSize, child: Image(color: Colors.grey, image: AssetImage(imgAddress)));

  SizedBox activeIconWidget(String imgAddress) {
    return SizedBox(width: iconSize, height: iconSize, child: Image(image: AssetImage(imgAddress)));
  }
}
