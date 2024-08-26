import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class Preferences extends ChangeNotifier {
  static const _boxName = 'preferencesBox';
  static const _isDarkModeKey = 'isDarkMode';

  late Box<bool> _preferencesBox;

  Preferences() {
    _init();
  }

  Future<void> _init() async {
    _preferencesBox = await Hive.openBox<bool>(_boxName);
    notifyListeners();
  }

  bool get isDarkMode {
    return _preferencesBox.get(_isDarkModeKey, defaultValue: false) ?? false;
  }

  Future<void> toggleDarkMode() async {
    final currentMode = isDarkMode;
    await _preferencesBox.put(_isDarkModeKey, !currentMode);
    notifyListeners();
  }

  // Add other settings management methods here
}
