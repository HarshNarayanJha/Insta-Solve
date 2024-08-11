import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  Brightness userTheme = Brightness.dark;

  void setTheme(Brightness theme) {
    userTheme = theme;
    notifyListeners();
  }
}
