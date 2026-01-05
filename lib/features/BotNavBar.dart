import 'package:flutter/material.dart';
import 'package:loginpage/features/homeWork/Presentaion/pages/HomeWorkPage.dart';
import 'package:loginpage/features/login_screen/Presentation/pages/home_screen.dart';
import 'package:loginpage/features/profile/Presentaion/pages/HomeWorkPage.dart';
import 'package:loginpage/main.dart';

class MyBotNavBar extends StatefulWidget {
  const MyBotNavBar({super.key});
  @override
  State<MyBotNavBar> createState() => _MyBotNavBarState();
}

class _MyBotNavBarState extends State<MyBotNavBar> {
  int _currentIndex = 0;
  final List<Widget> _screens = [HomePage(), Homeworkpage(), ProfilePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [],
      ),
    );
  }
}
