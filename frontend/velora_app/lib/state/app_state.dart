import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  int _currentBottomIndex = 0;

  ThemeMode get themeMode => _themeMode;
  int get currentBottomIndex => _currentBottomIndex;

  void useSystemTheme() {
    _themeMode = ThemeMode.system;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setBottomIndex(int index) {
    _currentBottomIndex = index;
    notifyListeners();
  }
}
