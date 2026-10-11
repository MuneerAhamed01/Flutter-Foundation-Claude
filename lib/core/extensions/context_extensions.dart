import 'package:flutter/material.dart';
import 'package:flutter_foundation/core/theme/app_colors.dart';

extension ContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;

  Size get screenSize => MediaQuery.sizeOf(this);
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  void showSnack(String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
