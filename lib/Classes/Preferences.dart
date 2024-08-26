import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences extends ChangeNotifier {
  static const _isDarkModeKey = 'isDarkMode';

  late SharedPreferences _preferences;

  Preferences() {
    _init();
  }

  Future<void> _init() async {
    _preferences = await SharedPreferences.getInstance();
    notifyListeners();
  }

  bool get isDarkMode {
    return _preferences.getBool(_isDarkModeKey) ?? false;
  }

  Future<void> toggleDarkMode() async {
    final currentMode = isDarkMode;
    await _preferences.setBool(_isDarkModeKey, !currentMode);
    notifyListeners();
  }
}
