import 'package:flutter/widgets.dart';

/// 4pt spacing scale. Use these instead of magic numbers.
abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  /// Default horizontal padding for screens.
  static const screen = EdgeInsets.symmetric(horizontal: lg);
}

/// Fixed gap for Rows/Columns: `const VGap(AppSpacing.md)`.
class VGap extends StatelessWidget {
  const VGap(this.size, {super.key});

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(height: size);
}

class HGap extends StatelessWidget {
  const HGap(this.size, {super.key});

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(width: size);
}
