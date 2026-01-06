import 'package:flutter/material.dart';

class Appcolor {
  static Color lightblack = const Color.fromARGB(94, 0, 0, 0);
  static Color redColor = const Color.fromARGB(255, 238, 90, 79);
  static Color blueColor = const Color.fromARGB(255, 53, 224, 210);
  static Color greenColor = const Color.fromARGB(255, 74, 228, 94);
  static Color yellowColor = Color.fromARGB(255, 209, 195, 65);
  static Color blackColor = const Color.fromARGB(255, 19, 18, 18);
  static Color whiteColor = const Color.fromARGB(255, 255, 255, 255);

  // // ===== RED THEME =====
  // static const redPrimary = Color.fromARGB(255, 238, 90, 79);
  // static const redBackground = Color.fromARGB(255, 255, 235, 235);
  // static const redCard = Color.fromARGB(255, 255, 210, 210);
  // static const redAccent = Color.fromARGB(255, 255, 150, 140);
  // static const redTextPrimary = Color.fromARGB(255, 102, 0, 0);
  // static const redTextSecondary = Color.fromARGB(255, 153, 51, 51);
  // static const redIcon = Color.fromARGB(255, 102, 0, 0);

  // // ===== GREEN THEME =====
  // static const greenPrimary = Color.fromARGB(255, 74, 228, 94);
  // static const greenBackground = Color.fromARGB(255, 235, 255, 235);
  // static const greenCard = Color.fromARGB(255, 200, 255, 200);
  // static const greenAccent = Color.fromARGB(255, 150, 255, 150);
  // static const greenTextPrimary = Color.fromARGB(255, 0, 102, 0);
  // static const greenTextSecondary = Color.fromARGB(255, 0, 153, 0);
  // static const greenIcon = Color.fromARGB(255, 0, 102, 0);

  // ===== BLUE THEME =====
  // ------------------------
  // Solid Colors
  // ------------------------
  static const Color primary = Color(0xFF1E3A8A); // Deep Blue
  static const Color primaryLight = Color(0xFF3B82F6); // Sky Blue
  static const Color accent = Color(0xFF06B6D4); // Cyan
  static const Color background = Color(0xFFEFF6FF); // Light Blue
  static const Color surface = Color(0xFFFFFFFF); // White for cards
  static const Color textPrimary = Color(0xFF1E40AF); // Dark Blue
  static const Color textSecondary = Color(0xFF64748B); // Grayish Blue
  static const Color error = Color(0xFFEF4444); // Red
  static const Color success = Color(0xFF22C55E); // Green

  // ------------------------
  // Gradients
  // ------------------------
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF22C55E), Color(0xFF4ADE80)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFF87171)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ===== YELLOW THEME =====
  // static const yellowPrimary = Color.fromARGB(255, 209, 195, 65);
  // static const yellowBackground = Color.fromARGB(255, 255, 255, 230);
  // static const yellowCard = Color.fromARGB(255, 255, 255, 180);
  // static const yellowAccent = Color.fromARGB(255, 255, 255, 150);
  // static const yellowTextPrimary = Color.fromARGB(255, 102, 102, 0);
  // static const yellowTextSecondary = Color.fromARGB(255, 153, 153, 51);
  // static const yellowIcon = Color.fromARGB(255, 102, 102, 0);

  // // ===== BLACK THEME =====
  // static const blackPrimary = Color.fromARGB(255, 19, 18, 18);
  // static const blackBackground = Color.fromARGB(255, 50, 50, 50);
  // static const blackCard = Color.fromARGB(255, 80, 80, 80);
  // static const blackAccent = Color.fromARGB(255, 120, 120, 120);
  // static const blackTextPrimary = Color.fromARGB(255, 245, 243, 243);
  // static const blackTextSecondary = Color.fromARGB(255, 200, 200, 200);
  // static const blackIcon = Color.fromARGB(255, 245, 243, 243);

  // // ===== WHITE THEME =====
  // static const whitePrimary = Color.fromARGB(255, 245, 243, 243);
  // static const whiteBackground = Color.fromARGB(255, 255, 255, 255);
  // static const whiteCard = Color.fromARGB(255, 245, 245, 245);
  // static const whiteAccent = Color.fromARGB(255, 220, 220, 220);
  // static const whiteTextPrimary = Color.fromARGB(255, 19, 18, 18);
  // static const whiteTextSecondary = Color.fromARGB(255, 80, 80, 80);
  // static const whiteIcon = Color.fromARGB(255, 19, 18, 18);
}
