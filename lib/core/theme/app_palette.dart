import 'package:flutter/material.dart';

/// Raw brand colors. The only place hex values live.
/// Widgets should never use these directly; use `context.colors` / `context.appColors`.
abstract final class AppPalette {
  // TODO(setup): replace with your brand colors.
  static const brand = Color(0xFF2E7D32);
  static const brandSecondary = Color(0xFF00897B);

  static const success = Color(0xFF2E7D32);
  static const warning = Color(0xFFED6C02);
  static const info = Color(0xFF0288D1);
  static const error = Color(0xFFD32F2F);

  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);

  static const neutral50 = Color(0xFFF8FAF9);
  static const neutral100 = Color(0xFFF1F4F2);
  static const neutral200 = Color(0xFFE2E8E4);
  static const neutral300 = Color(0xFFCBD5CF);
  static const neutral500 = Color(0xFF6B7A71);
  static const neutral700 = Color(0xFF37423B);
  static const neutral800 = Color(0xFF1F2722);
  static const neutral900 = Color(0xFF121714);
}
