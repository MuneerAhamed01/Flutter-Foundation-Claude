import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_foundation/core/di/injection.dart';
import 'package:flutter_foundation/core/router/app_routes.dart';
import 'package:flutter_foundation/core/widgets/app_error_view.dart';
import 'package:flutter_foundation/features/home/presentation/view_models/home_view_model.dart';
import 'package:flutter_foundation/features/home/presentation/views/home_view.dart';
// [scaffold:imports]

/// App navigation. Each route creates its ViewModel via [sl], so the
/// ViewModel is disposed when the route is popped.
final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  // TODO(auth): add a `redirect` that checks SessionManager.isLoggedIn.
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (_, _) => BlocProvider(
        create: (_) => sl<HomeViewModel>()..load(),
        child: const HomeView(),
      ),
    ),
    // [scaffold:routes]
  ],
  errorBuilder: (_, state) =>
      AppErrorView(message: 'Page not found: ${state.uri}'),
);
