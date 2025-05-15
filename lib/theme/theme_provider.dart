import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeBoxName = 'theme_box';
  static const String _themeModeKey = 'theme_mode';
  late Box<int> _themeBox;
  ThemeMode _themeMode = ThemeMode.light;

  ThemeProvider() {
    _initThemeBox();
  }

  ThemeMode get themeMode => _themeMode;

  Future<void> _initThemeBox() async {
    _themeBox = await Hive.openBox<int>(_themeBoxName);
    final savedThemeMode = _themeBox.get(_themeModeKey);
    if (savedThemeMode != null) {
      _themeMode = ThemeMode.values[savedThemeMode];
      notifyListeners();
    }
  }

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _themeBox.put(_themeModeKey, _themeMode.index);
    notifyListeners();
  }
}
