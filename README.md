# Flutter Foundation

Flutter app (iOS + Android) built on a reusable foundation: **BLoC + MVVM**, Retrofit/Dio, Freezed, get_it, go_router, secure storage and `dev`/`prod` flavors.

## Quick start

```bash
make setup      # pub get + code generation
make run-dev    # or: make run-prod
make help       # list every command
```

Flutter version is pinned in `.fvmrc` (3.47.4). Commands use FVM when installed.

| Flavor | Bundle / application ID    | App name          | Entry point          |
|--------|----------------------------|-------------------|----------------------|
| dev    | `com.foundation.app.dev`  | Flutter Foundation Dev | `lib/main_dev.dart`  |
| prod   | `com.foundation.app`      | Flutter Foundation     | `lib/main_prod.dart` |

Both flavors can be installed side by side. VS Code launch configs are in `.vscode/launch.json`; in Xcode pick the `dev` or `prod` scheme.

## Architecture (MVVM with BLoC)

```
View (Widget) ──intent──▶ ViewModel (Cubit/Bloc) ──▶ Repository ──▶ Api (Retrofit) ──▶ Dio
     ▲                          │
     └──────── state ───────────┘
```

- **View** renders state and forwards user actions. No business logic.
- **ViewModel** is a `Cubit` (or a `Bloc` when you need event transforms such as debounce). It exposes immutable Freezed state.
- **Repository** returns `Result<T>` (`Ok` / `Err(Failure)`), never throws. Wrap calls with `safeApiCall`.
- **Api** is a Retrofit interface; the generator writes the Dio code.

```
lib/
├── main_dev.dart / main_prod.dart   # flavor entry points
├── bootstrap.dart                   # shared startup: DI, error handling, BlocObserver
├── app/                             # MaterialApp.router, BlocObserver
├── core/
│   ├── base/        # ViewState<T> (freezed) + ViewStateBuilder widget
│   ├── config/      # AppConfig per flavor (base URL, logging, timeouts)
│   ├── di/          # get_it setup (`sl`)
│   ├── extensions/  # context.colors, context.textTheme, context.appColors, ...
│   ├── network/     # DioClient, AuthInterceptor, Failure, Result, safeApiCall
│   ├── router/      # go_router config + AppRoutes constants
│   ├── session/     # SessionManager (tokens + session-expired stream)
│   ├── storage/     # SecureStorageService
│   ├── theme/       # palette, AppColors extension, typography, spacing, radius, AppTheme, ThemeCubit
│   ├── utils/       # AppLogger
│   └── widgets/     # AppButton, AppTextField, AppLoader, AppErrorView, AppEmptyView
└── features/
    └── <feature>/
        ├── data/{models,sources,repositories}
        ├── presentation/{view_models,views,widgets}
        └── <feature>_injection.dart
```

`features/home` is a working sample (posts from a public API on the dev flavor). Delete it when you add real features.

## Theme

- Hex values live **only** in `core/theme/app_palette.dart`.
- Widgets read colors through `context.colors` (Material `ColorScheme`) and `context.appColors` (success, warning, info, border, mutedText).
- Spacing and radius: `AppSpacing.*`, `AppRadius.*`, `VGap` / `HGap`.
- Component styles (buttons, inputs, cards, app bar, ...) are defined once in `AppTheme`. Light and dark are both supported; switch with `ThemeCubit`.
- Custom font: add files under `assets/fonts`, declare them in `pubspec.yaml`, set `AppTypography.fontFamily`.

## Networking & auth

- `AuthInterceptor` adds `Authorization: Bearer <token>` from secure storage.
- On 401 it calls an optional `TokenRefresher` and retries once; otherwise it clears tokens and fires `SessionManager.onSessionExpired` (handle it in `app.dart`).
- For a public endpoint, add `@Extra({AuthInterceptor.skipAuth: true})` to the Retrofit method.

## Commands

| Command | What it does |
|---|---|
| `make feature name=reports` | Scaffolds a full feature (model, api, repository, ViewModel, view, DI, route) and wires it in |
| `make gen` / `make watch` | Code generation (freezed, json_serializable, retrofit) |
| `make apk-dev`, `make apk-prod`, `make aab-prod` | Android builds |
| `make ipa-dev`, `make ipa-prod` | iOS builds |
| `make flavors` | Re-generate native flavor config after editing `flavorizr.yaml` |
| `make new-project dest=../my_app pkg=my_app bundle=com.acme.myapp name="My App"` | Creates a new app from this foundation with renamed package, bundle IDs and app name |

## Before release (TODO)

- Set real base URLs in `lib/core/config/app_config.dart`.
- Android: add a release signing config in `android/app/build.gradle.kts`.
- iOS: set your Team in Xcode for both schemes.
- Replace app icons (`AppIcon-dev` / `AppIcon-prod` in `ios/Runner/Assets.xcassets`, `android/app/src/main/res/mipmap-*`).
