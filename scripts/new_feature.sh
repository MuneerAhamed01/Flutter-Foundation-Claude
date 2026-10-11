#!/usr/bin/env bash
# Scaffolds a feature (model, Retrofit API, repository, ViewModel, view, DI, route)
# and wires it into injection.dart, app_router.dart and app_routes.dart.
#
#   ./scripts/new_feature.sh reports        # or: make feature name=reports
set -euo pipefail

NAME="${1:-}"
if [[ ! "$NAME" =~ ^[a-z][a-z0-9_]*$ ]]; then
  echo "Usage: $0 <feature_name_in_snake_case>" >&2
  exit 1
fi

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
PKG="$(awk '/^name:/{print $2; exit}' pubspec.yaml)"
PASCAL="$(echo "$NAME" | perl -pe 's/(^|_)(\w)/\U$2/g')"
CAMEL="$(echo "$PASCAL" | perl -pe 's/^(\w)/\l$1/')"
PATH_SEG="$(echo "$NAME" | tr '_' '-')"
DIR="lib/features/$NAME"

if [[ -d "$DIR" ]]; then
  echo "Feature '$NAME' already exists at $DIR" >&2
  exit 1
fi

mkdir -p "$DIR"/data/{models,sources,repositories} "$DIR"/presentation/{view_models,views,widgets}

cat > "$DIR/data/models/${NAME}_model.dart" <<EOF
import 'package:freezed_annotation/freezed_annotation.dart';

part '${NAME}_model.freezed.dart';
part '${NAME}_model.g.dart';

@freezed
abstract class ${PASCAL}Model with _\$${PASCAL}Model {
  const factory ${PASCAL}Model({required int id}) = _${PASCAL}Model;

  factory ${PASCAL}Model.fromJson(Map<String, dynamic> json) =>
      _\$${PASCAL}ModelFromJson(json);
}
EOF

cat > "$DIR/data/sources/${NAME}_api.dart" <<EOF
import 'package:dio/dio.dart';
import 'package:${PKG}/features/${NAME}/data/models/${NAME}_model.dart';
import 'package:retrofit/retrofit.dart';

part '${NAME}_api.g.dart';

@RestApi()
abstract class ${PASCAL}Api {
  factory ${PASCAL}Api(Dio dio) = _${PASCAL}Api;

  // TODO: replace with the real endpoint.
  @GET('/${PATH_SEG}')
  Future<List<${PASCAL}Model>> getAll();
}
EOF

cat > "$DIR/data/repositories/${NAME}_repository.dart" <<EOF
import 'package:${PKG}/core/network/result.dart';
import 'package:${PKG}/core/network/safe_api_call.dart';
import 'package:${PKG}/features/${NAME}/data/models/${NAME}_model.dart';
import 'package:${PKG}/features/${NAME}/data/sources/${NAME}_api.dart';

abstract interface class ${PASCAL}Repository {
  Future<Result<List<${PASCAL}Model>>> getAll();
}

class ${PASCAL}RepositoryImpl implements ${PASCAL}Repository {
  const ${PASCAL}RepositoryImpl(this._api);

  final ${PASCAL}Api _api;

  @override
  Future<Result<List<${PASCAL}Model>>> getAll() => safeApiCall(_api.getAll);
}
EOF

cat > "$DIR/presentation/view_models/${NAME}_view_model.dart" <<EOF
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:${PKG}/core/base/view_state.dart';
import 'package:${PKG}/core/network/result.dart';
import 'package:${PKG}/features/${NAME}/data/models/${NAME}_model.dart';
import 'package:${PKG}/features/${NAME}/data/repositories/${NAME}_repository.dart';

class ${PASCAL}ViewModel extends Cubit<ViewState<List<${PASCAL}Model>>> {
  ${PASCAL}ViewModel(this._repository) : super(const ViewState.initial());

  final ${PASCAL}Repository _repository;

  Future<void> load() async {
    emit(const ViewState.loading());
    final result = await _repository.getAll();
    emit(switch (result) {
      Ok(:final data) => ViewState.success(data),
      Err(:final failure) => ViewState.failure(failure),
    });
  }
}
EOF

cat > "$DIR/presentation/views/${NAME}_view.dart" <<EOF
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:${PKG}/core/base/view_state_builder.dart';
import 'package:${PKG}/core/theme/app_spacing.dart';
import 'package:${PKG}/features/${NAME}/data/models/${NAME}_model.dart';
import 'package:${PKG}/features/${NAME}/presentation/view_models/${NAME}_view_model.dart';

class ${PASCAL}View extends StatelessWidget {
  const ${PASCAL}View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('${PASCAL}')),
      body: ViewStateBuilder<${PASCAL}ViewModel, List<${PASCAL}Model>>(
        onRetry: context.read<${PASCAL}ViewModel>().load,
        builder: (context, items) => ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: items.length,
          itemBuilder: (_, i) => ListTile(title: Text('#\${items[i].id}')),
        ),
      ),
    );
  }
}
EOF

cat > "$DIR/${NAME}_injection.dart" <<EOF
import 'package:get_it/get_it.dart';
import 'package:${PKG}/features/${NAME}/data/repositories/${NAME}_repository.dart';
import 'package:${PKG}/features/${NAME}/data/sources/${NAME}_api.dart';
import 'package:${PKG}/features/${NAME}/presentation/view_models/${NAME}_view_model.dart';

void register${PASCAL}Dependencies(GetIt sl) {
  sl
    ..registerLazySingleton(() => ${PASCAL}Api(sl()))
    ..registerLazySingleton<${PASCAL}Repository>(() => ${PASCAL}RepositoryImpl(sl()))
    ..registerFactory(() => ${PASCAL}ViewModel(sl()));
}
EOF

# Wire into DI, routes and router via the [scaffold:*] markers.
insert_before() { # file marker line
  MARKER="$2" LINE="$3" perl -pi -e 's/^(\s*)\Q$ENV{MARKER}\E$/$1$ENV{LINE}\n$1$ENV{MARKER}/' "$1"
}
insert_before lib/core/di/injection.dart '// [scaffold:imports]' \
  "import 'package:${PKG}/features/${NAME}/${NAME}_injection.dart';"
insert_before lib/core/di/injection.dart '// [scaffold:registrations]' \
  "register${PASCAL}Dependencies(sl);"
insert_before lib/core/router/app_routes.dart '// [scaffold:routes]' \
  "static const ${CAMEL} = '/${PATH_SEG}';"
insert_before lib/core/router/app_router.dart '// [scaffold:imports]' \
  "import 'package:${PKG}/features/${NAME}/presentation/view_models/${NAME}_view_model.dart';"
insert_before lib/core/router/app_router.dart '// [scaffold:imports]' \
  "import 'package:${PKG}/features/${NAME}/presentation/views/${NAME}_view.dart';"
insert_before lib/core/router/app_router.dart '// [scaffold:routes]' \
  "GoRoute(path: AppRoutes.${CAMEL}, builder: (_, _) => BlocProvider(create: (_) => sl<${PASCAL}ViewModel>()..load(), child: const ${PASCAL}View())),"

FLUTTER="$(command -v fvm >/dev/null 2>&1 && echo 'fvm dart' || echo 'dart')"
$FLUTTER run build_runner build --delete-conflicting-outputs >/dev/null
$FLUTTER format lib >/dev/null

echo "✓ Feature '$NAME' created in $DIR"
echo "  Route: AppRoutes.${CAMEL} ('/${PATH_SEG}') → context.push(AppRoutes.${CAMEL})"
