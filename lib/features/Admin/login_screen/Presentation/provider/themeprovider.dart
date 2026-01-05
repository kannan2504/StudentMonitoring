import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Themeprovider extends ChangeNotifier {
  static const String _bgColorKey = "background_color";

  Color _backgroundColor = Colors.blue;
  Color get backgroundColor => _backgroundColor;
  bool isDark = false;

  void changeMode() {
    isDark = !isDark;
    notifyListeners();
  }

  Future<void> loadColor() async {
    final prefs = await SharedPreferences.getInstance();
    final savedColor = prefs.getInt(_bgColorKey);

    if (savedColor != null) {
      _backgroundColor = Color(savedColor);
      notifyListeners();
    }
  }

  Future<void> SelectedColor(Color color) async {
    _backgroundColor = color;
    notifyListeners(); // 🔥 instant UI update

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_bgColorKey, color.value);
  }
}

class ThemeColorProvider extends ChangeNotifier {
  static const String _bgColorKey = "background_color";

  Color _backgroundColor = Colors.blue; // default
  Color get backgroundColor => _backgroundColor;

  ThemeColorProvider() {
    _loadColor();
  }

  Future<void> _loadColor() async {
    final prefs = await SharedPreferences.getInstance();
    final savedColor = prefs.getInt(_bgColorKey);

    if (savedColor != null) {
      _backgroundColor = Color(savedColor);
      notifyListeners();
    }
  }

  Future<void> changeBackgroundColor(Color color) async {
    _backgroundColor = color;
    notifyListeners(); // 🔥 instant UI update

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_bgColorKey, color.value);
  }
}
