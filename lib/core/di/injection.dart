import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_foundation/core/config/app_config.dart';
import 'package:flutter_foundation/core/network/dio_client.dart';
import 'package:flutter_foundation/core/session/session_manager.dart';
import 'package:flutter_foundation/core/storage/secure_storage_service.dart';
import 'package:flutter_foundation/core/theme/theme_cubit.dart';
import 'package:flutter_foundation/features/home/home_injection.dart';
// [scaffold:imports]

/// Global service locator.
final sl = GetIt.instance;

Future<void> configureDependencies(AppConfig config) async {
  sl
    // Core
    ..registerSingleton<AppConfig>(config)
    ..registerLazySingleton(() => const FlutterSecureStorage())
    ..registerLazySingleton(() => SecureStorageService(sl()))
    ..registerLazySingleton(() => SessionManager(sl()))
    ..registerLazySingleton<Dio>(
      () => DioClient.create(config: sl(), session: sl()),
    )
    ..registerLazySingleton(ThemeCubit.new);

  // Features: add one line per feature.
  registerHomeDependencies(sl);
  // [scaffold:registrations]
}
