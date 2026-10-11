import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Minimal logger. Swap the body for Crashlytics/Sentry in one place.
abstract final class AppLogger {
  static void debug(String message) {
    if (kDebugMode) developer.log(message, name: 'APP');
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: 'APP',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
