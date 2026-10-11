import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, text }

/// Standard button with a built-in loading state.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final onTap = isLoading ? null : onPressed;
    final child = isLoading
        ? const SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(label);
    final iconWidget = icon == null || isLoading ? null : Icon(icon);

    return switch (variant) {
      AppButtonVariant.primary =>
        iconWidget == null
            ? FilledButton(onPressed: onTap, child: child)
            : FilledButton.icon(
                onPressed: onTap,
                icon: iconWidget,
                label: child,
              ),
      AppButtonVariant.secondary =>
        iconWidget == null
            ? OutlinedButton(onPressed: onTap, child: child)
            : OutlinedButton.icon(
                onPressed: onTap,
                icon: iconWidget,
                label: child,
              ),
      AppButtonVariant.text =>
        iconWidget == null
            ? TextButton(onPressed: onTap, child: child)
            : TextButton.icon(onPressed: onTap, icon: iconWidget, label: child),
    };
  }
}
