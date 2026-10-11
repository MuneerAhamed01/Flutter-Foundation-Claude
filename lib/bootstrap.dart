import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foundation/app/app.dart';
import 'package:flutter_foundation/app/app_bloc_observer.dart';
import 'package:flutter_foundation/core/config/app_config.dart';
import 'package:flutter_foundation/core/di/injection.dart';
import 'package:flutter_foundation/core/utils/app_logger.dart';

/// Shared entry point for every flavor.
Future<void> bootstrap(AppConfig config) async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (details) {
      AppLogger.error('FlutterError', details.exception, details.stack);
    };

    await configureDependencies(config);
    if (config.isDev) Bloc.observer = const AppBlocObserver();

    runApp(const App());
  }, (error, stack) => AppLogger.error('Uncaught error', error, stack));
}
