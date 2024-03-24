import 'package:flutter/material.dart';
import 'package:karmafy/theme/dark_mode.dart';
import 'package:karmafy/theme/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  //* initially
  ThemeData _themeData = lightMode;

  //*get current themedata
  ThemeData get themeData => _themeData;
  //*is currently theme dark
  bool get isDarkMode => _themeData == darkMode;

  //*set theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  //*toggle theme
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
