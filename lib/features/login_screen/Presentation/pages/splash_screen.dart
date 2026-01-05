import 'package:flutter/material.dart';
import 'package:loginpage/core/constants/Appcolor.dart';
import 'package:loginpage/features/login_screen/Presentation/provider/themeprovider.dart';
import 'package:loginpage/main.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bgColor = context.watch<Themeprovider>().backgroundColor;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: bgColor),
        child: Align(
          alignment: AlignmentGeometry.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w800),
              ),
              Text("Select theme color for the app"),
              ColorSelector(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Appcolor.whiteColor,
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
                child: Text("Get Started", style: TextStyle(color: bgColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ColorSelector extends StatelessWidget {
  const ColorSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<Themeprovider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _colorCircle(context, Appcolor.redColor),
        _colorCircle(context, Appcolor.greenColor),
        _colorCircle(context, Appcolor.yellowColor),
        _colorCircle(context, Appcolor.blueColor),
      ],
    );
  }

  Widget _colorCircle(BuildContext context, Color color) {
    final provider = context.read<Themeprovider>();

    return GestureDetector(
      onTap: () => provider.SelectedColor(color),
      child: Container(
        margin: const EdgeInsets.all(8),
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    );
  }
}
