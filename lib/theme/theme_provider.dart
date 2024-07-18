import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  Brightness userTheme = Brightness.dark;

  void setTheme(theme) {
    userTheme = theme;
    notifyListeners();
  }
}
