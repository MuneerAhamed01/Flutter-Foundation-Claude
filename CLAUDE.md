# CLAUDE.md

Flutter app on the BLoC + MVVM foundation: Retrofit/Dio, Freezed, get_it, go_router, secure storage, `dev`/`prod` flavors. `README.md` has the architecture diagram and folder tree; don't re-derive them by exploring.

<!-- PORTING: edit only this block when reusing this file in another project. -->
## Project facts

- Package: `flutter_foundation` (imports are `package:flutter_foundation/...`)
- Flavors: `dev` → `lib/main_dev.dart`, `prod` → `lib/main_prod.dart`
- Flutter version: pinned in `.fvmrc`; the Makefile uses FVM when installed
- Config per flavor: `lib/core/config/app_config.dart`
- Reference feature (copy its patterns, don't explore for others): `lib/features/home/`

## Rule 0: automation first (saves tokens and prevents drift)

Before writing any file by hand, check whether a `make` target or script already does it. Run `make help` to list targets. Scripts are tested and deterministic; hand-written boilerplate is slow, costs tokens and drifts from the conventions.

| Task | Command | Never do |
|---|---|---|
| New feature (model, API, repository, ViewModel, view, DI, route) | `make feature name=<snake_case>` | Hand-write those files or wire DI/routes by hand |
| Regenerate `*.g.dart` / `*.freezed.dart` after changing models, APIs or states | `make gen` (`make watch` for long sessions) | Edit generated files, or call `build_runner` directly |
| Install deps + generate | `make setup` | `flutter pub get` plus manual codegen |
| Lint / format / test | `make analyze`, `make format`, `make test` | Skip them before finishing |
| Native flavor config (after editing `flavorizr.yaml`) | `make flavors` | Edit native flavor files by hand |
| Run / build | `make run-dev`, `make run-prod`, `make apk-*`, `make aab-prod`, `make ipa-*` | Long raw `flutter` commands with flavor flags |
| Separate new app from this foundation | `make new-project dest=… pkg=… bundle=… name=…` (only when asked) | Copy the folder manually |

If you catch yourself doing the same multi-step edit a second time, say so and propose a script or Makefile target instead of repeating it.

## Adding a feature

1. Check `lib/features/` first. If `<name>` exists, edit it in place and do **not** re-run the script.
2. Otherwise run `make feature name=<snake_case_name>`. It generates `lib/features/<name>/` (model, Retrofit API, repository, ViewModel, view, `<name>_injection.dart`), wires `injection.dart`, `app_routes.dart` and `app_router.dart`, and runs `build_runner`.
3. Edit only the generated files, and only for the real work:

| Change | File |
|---|---|
| Endpoint path / HTTP method | `data/sources/<name>_api.dart` |
| Model fields | `data/models/*_model.dart` (then `make gen`) |
| Repository methods, mapping | `data/repositories/<name>_repository.dart` |
| State and logic | `presentation/view_models/<name>_view_model.dart` |
| UI | `presentation/views/<name>_view.dart`, `presentation/widgets/` |

4. Run `make gen` if you touched a model, API or Freezed state, then `make analyze` and `make test`.

Do not regenerate or rewrite the scaffold. Do not remove the `// [scaffold:imports]`, `// [scaffold:registrations]` and `// [scaffold:routes]` markers; the script needs them. Never open `scripts/*.sh` to learn what they generate; the list above is enough.

## Token discipline

- Don't read `*.g.dart`, `*.freezed.dart`, `build/`, `.dart_tool/`, `ios/Pods`, `pubspec.lock`, or `android/`/`ios/` native files unless the task is native config.
- Don't scan the whole repo. Use the file map in `README.md` and the table above, then open only the file you'll edit.
- Prefer the reference feature as the pattern over reading `core/` internals.
- Run `make analyze` / `make test` and report only failures, not full output.

## Architecture rules

`View → ViewModel (Cubit/Bloc) → Repository → Api (Retrofit) → Dio`

- **View**: renders state, forwards user actions. No business logic, no direct repository/API/`sl` calls (the route creates the ViewModel via `BlocProvider`).
- **ViewModel**: `Cubit` by default; `Bloc` only when event transforms (debounce, droppable) are needed. State is immutable Freezed (`ViewState<T>` for single-load screens, a custom Freezed class for richer ones). Never import widgets or `BuildContext`.
- **Repository**: abstract interface plus `Impl`; returns `Result<T>` (`Ok` / `Err(Failure)`); wraps every API call in `safeApiCall`; never throws.
- **Api**: Retrofit interface only. Public endpoints use `@Extra({AuthInterceptor.skipAuth: true})`.
- **DI**: register in the feature's `<name>_injection.dart` (repositories as lazy singletons, ViewModels as factories). Use `sl` only at composition points (DI file, router), not inside views or repositories.
- **Navigation**: routes are constants in `AppRoutes`; add a route via `make feature`, not inline strings.

## Stability rules (apply to every change)

- After any `await` in a Cubit/Bloc, guard with `if (isClosed) return;` before `emit`. Leaving the screen mid-request otherwise throws `StateError`.
- Handle `Result` with an exhaustive `switch` on `Ok` / `Err`. Never use `!` on repository data.
- Never `catch (_)` silently. Log with `AppLogger`, and map to a `Failure`.
- No `print`; use `AppLogger`. Never log tokens, passwords or full auth headers.
- No hardcoded colors, spacing, radii or text styles. Use `context.colors`, `context.appColors`, `context.textTheme`, `AppSpacing`, `AppRadius`, `VGap`/`HGap`. Hex values live only in `core/theme/app_palette.dart`.
- Reuse `core/widgets` (`AppButton`, `AppTextField`, `AppLoader`, `AppErrorView`, `AppEmptyView`, `ViewStateBuilder`) before creating new ones.
- Secrets, base URLs and keys come from `AppConfig` / `--dart-define`, never hardcoded in feature code or committed.
- Dispose controllers, focus nodes and stream subscriptions you create.
- `const` constructors where possible; `package:` imports only (lint-enforced).

## Code style

- Match the surrounding code: naming, comment density, file layout. Comments explain why, not what.
- Files are `snake_case`; classes are `PascalCase` with these suffixes: `*Model`, `*Api`, `*Repository(Impl)`, `*ViewModel`, `*View`.
- Don't add new packages without asking. Check `pubspec.yaml` first; the stack already covers state, networking, DI, routing, storage and codegen.

## Tests

- New ViewModel → a `blocTest` with `mocktail` mocks of the repository (success and failure paths), mirroring the reference feature's test in `test/features/<name>/`.
- Touching `core/network` (interceptor, error mapping) or `SessionManager` → add or update a unit test for it.
- Bug fix → add a test that fails before the fix.

## Definition of done

1. `make gen` (if models, APIs or states changed)
2. `make analyze` is clean
3. `make test` passes
4. Report any step you skipped or couldn't run; don't claim success otherwise.

## Don't

- Don't edit generated files or the native flavor config by hand.
- Don't commit, push or change git config unless asked.
- Don't run `make new-project` unless asked to create a separate app.
- Don't delete the sample feature unless asked (README says to remove it once real features exist).
