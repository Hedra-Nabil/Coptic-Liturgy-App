import 'package:flutter/material.dart';
import 'constants.dart';

class AppStateManager extends ChangeNotifier {
  bool _isDarkMode = false;
  double _fontSize = AppConstants.defaultFontSize;

  bool get isDarkMode => _isDarkMode;
  double get fontSize => _fontSize;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void increaseFontSize() {
    if (_fontSize < AppConstants.maxFontSize) {
      _fontSize += AppConstants.fontSizeStep;
      notifyListeners();
    }
  }

  void decreaseFontSize() {
    if (_fontSize > AppConstants.minFontSize) {
      _fontSize -= AppConstants.fontSizeStep;
      notifyListeners();
    }
  }
}