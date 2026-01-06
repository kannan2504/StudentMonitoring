import 'package:flutter/material.dart';

class StudentDashBoard extends StatefulWidget {
  const StudentDashBoard({super.key});

  @override
  State<StudentDashBoard> createState() => _StudentDashBoardState();
}

class _StudentDashBoardState extends State<StudentDashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}
