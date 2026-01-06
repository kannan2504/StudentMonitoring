import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:loginpage/core/constants/Appcolor.dart';
import 'package:motion_tab_bar_v2/motion-badge.widget.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';

class StudentBottomNav extends StatefulWidget {
  const StudentBottomNav({super.key});

  @override
  State<StudentBottomNav> createState() => _StudentBottomNavState();
}

class _StudentBottomNavState extends State<StudentBottomNav>
    with TickerProviderStateMixin {
  int _currentIndex = 0; // track selected tab

  late MotionTabBarController _motionTabBarController;

  final List<Widget> _screens = [
    const DashboardPage(),
    const ChatPage(),
    const AssignmentPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 4, // number of tabs
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
        initialSelectedTab: "Dashboard",
        labels: const ["Dashboard", "Chat", "HomeWork", "Profile"],
        icons: const [
          Icons.dashboard,
          Icons.chat,
          Icons.assignment,
          Icons.person,
        ],
        tabSize: 50,
        tabBarHeight: 60,
        tabIconSize: 28.0,
        tabIconSelectedSize: 34.0,
        tabIconColor: Colors.white70,
        tabSelectedColor: Appcolor.whiteColor,
        tabIconSelectedColor: Appcolor.primaryLight,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white70,
        ),

        tabBarColor: Colors.blueAccent,
        onTabItemSelected: (index) {
          setState(() {
            _motionTabBarController.index = index;
          });
        },
      ),
    );
  }
}

// Example Pages
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('📊 Dashboard Page'));
  }
}

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('💬 Chat Page'));
  }
}

class AssignmentPage extends StatelessWidget {
  const AssignmentPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('📝 Assignments Page'));
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('👤 Profile Page'));
  }
}
