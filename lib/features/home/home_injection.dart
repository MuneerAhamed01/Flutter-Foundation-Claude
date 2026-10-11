import 'package:get_it/get_it.dart';
import 'package:flutter_foundation/features/home/data/repositories/home_repository.dart';
import 'package:flutter_foundation/features/home/data/sources/home_api.dart';
import 'package:flutter_foundation/features/home/presentation/view_models/home_view_model.dart';

/// Feature-level DI: API -> Repository (singletons), ViewModel (factory).
void registerHomeDependencies(GetIt sl) {
  sl
    ..registerLazySingleton(() => HomeApi(sl()))
    ..registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()))
    ..registerFactory(() => HomeViewModel(sl()));
}
