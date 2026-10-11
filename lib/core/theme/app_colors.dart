import 'package:flutter/material.dart';
import 'package:flutter_foundation/core/theme/app_palette.dart';

/// Semantic colors Material's [ColorScheme] doesn't cover.
/// Access with `context.appColors.success`.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
    required this.info,
    required this.onInfo,
    required this.border,
    required this.mutedText,
  });

  final Color success;
  final Color onSuccess;
  final Color warning;
  final Color onWarning;
  final Color info;
  final Color onInfo;
  final Color border;
  final Color mutedText;

  static const light = AppColors(
    success: AppPalette.success,
    onSuccess: AppPalette.white,
    warning: AppPalette.warning,
    onWarning: AppPalette.white,
    info: AppPalette.info,
    onInfo: AppPalette.white,
    border: AppPalette.neutral200,
    mutedText: AppPalette.neutral500,
  );

  static const dark = AppColors(
    success: Color(0xFF81C784),
    onSuccess: AppPalette.black,
    warning: Color(0xFFFFB74D),
    onWarning: AppPalette.black,
    info: Color(0xFF4FC3F7),
    onInfo: AppPalette.black,
    border: AppPalette.neutral700,
    mutedText: AppPalette.neutral300,
  );

  @override
  AppColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? warning,
    Color? onWarning,
    Color? info,
    Color? onInfo,
    Color? border,
    Color? mutedText,
  }) {
    return AppColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      border: border ?? this.border,
      mutedText: mutedText ?? this.mutedText,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      border: Color.lerp(border, other.border, t)!,
      mutedText: Color.lerp(mutedText, other.mutedText, t)!,
    );
  }
}
