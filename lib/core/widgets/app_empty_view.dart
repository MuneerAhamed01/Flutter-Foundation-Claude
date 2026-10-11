import 'package:flutter/material.dart';
import 'package:flutter_foundation/core/extensions/context_extensions.dart';
import 'package:flutter_foundation/core/theme/app_spacing.dart';

class AppEmptyView extends StatelessWidget {
  const AppEmptyView({
    required this.message,
    this.icon = Icons.inbox_outlined,
    super.key,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: context.appColors.mutedText),
          const VGap(AppSpacing.md),
          Text(
            message,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.appColors.mutedText,
            ),
          ),
        ],
      ),
    );
  }
}
