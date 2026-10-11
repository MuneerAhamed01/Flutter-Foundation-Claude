import 'package:flutter/material.dart';
import 'package:flutter_foundation/core/theme/app_colors.dart';
import 'package:flutter_foundation/core/theme/app_palette.dart';
import 'package:flutter_foundation/core/theme/app_radius.dart';
import 'package:flutter_foundation/core/theme/app_spacing.dart';
import 'package:flutter_foundation/core/theme/app_typography.dart';

/// Builds light and dark [ThemeData] from the design tokens.
/// Component styling lives here so widgets stay free of styling code.
abstract final class AppTheme {
  static ThemeData get light => _build(
    ColorScheme.fromSeed(
      seedColor: AppPalette.brand,
      primary: AppPalette.brand,
      secondary: AppPalette.brandSecondary,
      error: AppPalette.error,
      surface: AppPalette.white,
    ),
    AppColors.light,
  );

  static ThemeData get dark => _build(
    ColorScheme.fromSeed(
      seedColor: AppPalette.brand,
      brightness: Brightness.dark,
      surface: AppPalette.neutral900,
    ),
    AppColors.dark,
  );

  static ThemeData _build(ColorScheme colors, AppColors appColors) {
    final text = AppTypography.textTheme(colors);
    const buttonPadding = EdgeInsets.symmetric(
      horizontal: AppSpacing.xl,
      vertical: AppSpacing.md,
    );
    const buttonShape = RoundedRectangleBorder(borderRadius: AppRadius.lgAll);
    const buttonMinSize = Size.fromHeight(48);

    OutlineInputBorder inputBorder(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: AppRadius.lgAll,
          borderSide: BorderSide(color: color, width: width),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      brightness: colors.brightness,
      fontFamily: AppTypography.fontFamily,
      textTheme: text,
      scaffoldBackgroundColor: colors.surface,
      extensions: [appColors],
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: buttonMinSize,
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: text.labelLarge,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: buttonMinSize,
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonMinSize,
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: text.labelLarge,
          side: BorderSide(color: appColors.border),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(textStyle: text.labelLarge),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceContainerHighest.withValues(alpha: 0.4),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        hintStyle: text.bodyMedium?.copyWith(color: appColors.mutedText),
        border: inputBorder(appColors.border),
        enabledBorder: inputBorder(appColors.border),
        focusedBorder: inputBorder(colors.primary, 1.5),
        errorBorder: inputBorder(colors.error),
        focusedErrorBorder: inputBorder(colors.error, 1.5),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: colors.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lgAll,
          side: BorderSide(color: appColors.border),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: appColors.border,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        contentTextStyle: text.bodyMedium?.copyWith(
          color: colors.onInverseSurface,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xxl),
          ),
        ),
      ),
      dialogTheme: const DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.xlAll),
      ),
    );
  }
}
