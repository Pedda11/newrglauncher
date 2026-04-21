import 'package:flutter/material.dart';
import 'app_theme.dart';

class LauncherThemeController extends ChangeNotifier {
  double _hue;

  LauncherThemeController({
    double initialHue = 260,
  }) : _hue = initialHue;

  double get hue => _hue;

  ThemeData get theme => AppTheme.build(hue: _hue);

  void setHue(double value) {
    if (value == _hue) return;

    _hue = value;
    notifyListeners();
  }
}
