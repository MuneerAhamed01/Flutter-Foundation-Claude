import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foundation/core/config/app_config.dart';
import 'package:flutter_foundation/core/di/injection.dart';
import 'package:flutter_foundation/core/router/app_router.dart';
import 'package:flutter_foundation/core/session/session_manager.dart';
import 'package:flutter_foundation/core/theme/app_theme.dart';
import 'package:flutter_foundation/core/theme/theme_cubit.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final StreamSubscription<void> _sessionSub;

  @override
  void initState() {
    super.initState();
    _sessionSub = sl<SessionManager>().onSessionExpired.listen((_) {
      // TODO(auth): appRouter.go(AppRoutes.login);
    });
  }

  @override
  void dispose() {
    unawaited(_sessionSub.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = sl<AppConfig>();
    return BlocProvider.value(
      value: sl<ThemeCubit>(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) => MaterialApp.router(
          title: config.appName,
          debugShowCheckedModeBanner: config.isDev,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
