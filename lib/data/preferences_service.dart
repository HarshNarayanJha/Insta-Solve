import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:insta_solve/models/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const defaultGradeKey = 'grade';
  static const autosaveKey = 'autosave';
  static const darkModeKey = 'darkmode';
  static const customKeyKey = 'customApiKey';
  static const userKeyKey = 'userApiKey';

  Future saveSettings(Settings setting) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());

    await prefs.setInt(defaultGradeKey, setting.defaultGrade);
    await prefs.setBool(autosaveKey, setting.autosave);
    await prefs.setBool(darkModeKey, setting.darkMode);
    await prefs.setBool(customKeyKey, setting.customApiKey);

    await storage.write(key: userKeyKey, value: setting.userApiKey);

    log("Saved Preferences!");
  }

  Future<Settings> getSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());

    final defaultGrade = prefs.getInt(defaultGradeKey) ?? 0;
    final autosave = prefs.getBool(autosaveKey) ?? false;
    final darkMode = prefs.getBool(darkModeKey) ?? true;
    final customApiKey = prefs.getBool(customKeyKey) ?? false;

    String? userApiKey = await storage.read(key: userKeyKey);

    return Settings(
        defaultGrade: defaultGrade,
        autosave: autosave,
        darkMode: darkMode,
        customApiKey: customApiKey,
        userApiKey: userApiKey);
  }
}

AndroidOptions _getAndroidOptions() =>
    const AndroidOptions(encryptedSharedPreferences: true);
