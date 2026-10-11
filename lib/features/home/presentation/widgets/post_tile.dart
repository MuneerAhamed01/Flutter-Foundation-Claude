import 'package:flutter/material.dart';
import 'package:flutter_foundation/core/extensions/context_extensions.dart';
import 'package:flutter_foundation/core/theme/app_spacing.dart';
import 'package:flutter_foundation/features/home/data/models/post_model.dart';

class PostTile extends StatelessWidget {
  const PostTile({required this.post, super.key});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.title, style: context.textTheme.titleMedium),
            const VGap(AppSpacing.xs),
            Text(
              post.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.appColors.mutedText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
