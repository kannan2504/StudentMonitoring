import 'package:flutter/material.dart';
import 'package:loginpage/core/constants/Appcolor.dart';
import 'package:loginpage/features/Admin/login_screen/Presentation/pages/home_screen.dart';
import 'package:loginpage/features/Admin/login_screen/Presentation/pages/student_lists.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardstate();
}

class _AdminDashboardstate extends State<AdminDashboard>
    with TickerProviderStateMixin {
  int _currentIndex = 0; // track selected tab

  late MotionTabBarController _motionTabBarController;

  final List<Widget> _screens = [HomePage(), StudentLists(), AssignmentPage()];

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 3, // number of tabs
      vsync: this,
    );
  }

  @override
  void dispose() {
    _motionTabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_motionTabBarController.index],
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController,
        initialSelectedTab: "homepage",
        labels: const ["homepage", "list", "HomeWork"],
        icons: const [Icons.home, Icons.list, Icons.assignment],
        tabSize: 50,
        tabBarHeight: 60,
        tabIconSize: 28.0,
        tabIconSelectedSize: 34.0,
        tabIconColor: Colors.white70,
        tabSelectedColor: Appcolor.whiteColor,
        tabIconSelectedColor: Appcolor.bottomNavActiveIcon,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white70,
        ),

        tabBarColor: Appcolor.bottomNavBackground,
        onTabItemSelected: (index) {
          setState(() {
            _motionTabBarController.index = index;
          });
        },
      ),
    );
  }
}

class AssignmentPage extends StatelessWidget {
  const AssignmentPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('📝 Announcements Page'));
  }
}
