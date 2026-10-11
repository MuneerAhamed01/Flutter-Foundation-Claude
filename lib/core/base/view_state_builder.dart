import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foundation/core/base/view_state.dart';
import 'package:flutter_foundation/core/network/failure.dart';
import 'package:flutter_foundation/core/widgets/app_error_view.dart';
import 'package:flutter_foundation/core/widgets/app_loader.dart';

/// Renders a [ViewState] from ViewModel [VM] with default loading/error UI.
///
/// ```dart
/// ViewStateBuilder<HomeViewModel, List<Post>>(
///   onRetry: context.read<HomeViewModel>().load,
///   builder: (context, posts) => PostList(posts),
/// )
/// ```
class ViewStateBuilder<VM extends StateStreamable<ViewState<T>>, T>
    extends StatelessWidget {
  const ViewStateBuilder({
    required this.builder,
    this.onRetry,
    this.loadingBuilder,
    this.failureBuilder,
    super.key,
  });

  final Widget Function(BuildContext context, T data) builder;
  final VoidCallback? onRetry;
  final WidgetBuilder? loadingBuilder;
  final Widget Function(BuildContext context, Failure failure)? failureBuilder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VM, ViewState<T>>(
      builder: (context, state) => switch (state) {
        ViewInitial() ||
        ViewLoading() => loadingBuilder?.call(context) ?? const AppLoader(),
        ViewSuccess(:final data) => builder(context, data),
        ViewFailure(:final failure) =>
          failureBuilder?.call(context, failure) ??
              AppErrorView(message: failure.message, onRetry: onRetry),
      },
    );
  }
}
