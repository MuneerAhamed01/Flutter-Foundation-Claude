import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foundation/core/base/view_state_builder.dart';
import 'package:flutter_foundation/core/theme/app_spacing.dart';
import 'package:flutter_foundation/core/theme/theme_cubit.dart';
import 'package:flutter_foundation/core/widgets/app_empty_view.dart';
import 'package:flutter_foundation/features/home/data/models/post_model.dart';
import 'package:flutter_foundation/features/home/presentation/view_models/home_view_model.dart';
import 'package:flutter_foundation/features/home/presentation/widgets/post_tile.dart';

/// View: renders state and forwards user intent to the ViewModel. No logic.
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<HomeViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Foundation'),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            icon: const Icon(Icons.brightness_6_outlined),
            onPressed: context.read<ThemeCubit>().toggle,
          ),
        ],
      ),
      body: ViewStateBuilder<HomeViewModel, List<PostModel>>(
        onRetry: viewModel.load,
        builder: (context, posts) {
          if (posts.isEmpty) return const AppEmptyView(message: 'No posts');
          return RefreshIndicator.adaptive(
            onRefresh: viewModel.load,
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: posts.length,
              separatorBuilder: (_, _) => const VGap(AppSpacing.md),
              itemBuilder: (_, i) => PostTile(post: posts[i]),
            ),
          );
        },
      ),
    );
  }
}
