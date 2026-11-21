import 'package:flutter/material.dart';

class ThemeModeController extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;

  ThemeMode get mode => _mode;

  void setDarkMode(bool enabled) {
    _mode = enabled ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class ThemeModeScope extends InheritedNotifier<ThemeModeController> {
  const ThemeModeScope({
    super.key,
    required ThemeModeController controller,
    required super.child,
  }) : super(notifier: controller);

  static ThemeModeController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeModeScope>();
    assert(scope != null, 'ThemeModeScope is missing above this context.');
    return scope!.notifier!;
  }
}
