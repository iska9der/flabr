# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flabr is an unofficial mobile client for habr.com built with Flutter. It supports Android, iOS, and Web platforms with features including dark/light themes, authorization, feed customization, and AI-powered article summaries using YandexGPT.

## Architecture

The project follows a clean architecture pattern with clear separation of concerns:

### Core Structure

- **`lib/bloc/`** - Business logic layer using BLoC pattern (flutter_bloc)
  - Contains feature-specific BLoCs and Cubits: auth, profile, publication, user, company, hub, search, settings, tracker
  - All BLoCs follow the convention: `<feature>_bloc.dart` or `<feature>_cubit.dart` with corresponding state files

- **`lib/data/`** - Data layer
  - `model/` - Data models (using freezed and json_serializable for code generation)
  - `repository/` - Repository implementations for data access
  - `service/` - API and service clients
  - `exception/` - Custom exception definitions

- **`lib/presentation/`** - Presentation layer
  - `app/` - Application initialization and configuration (see detailed structure below)
  - `page/` - Screen implementations organized by feature
  - `widget/` - Reusable widgets
  - `theme/` - Theme configuration and styling
  - `extension/` - Dart/Flutter extensions

- **`lib/feature/`** - Self-contained feature modules
  - Each feature contains its own cubit, widgets, and models
  - Features: image_action, most_reading, profile_subscribe, publication_download, publication_list, scaffold, scroll

- **`lib/core/`** - Core utilities and infrastructure
  - `component/` - Shared components (http, storage, router, logger, shortcuts)
  - `constants/` - App-wide constants
  - `helper/` - Utility functions

- **`lib/di/`** - Dependency injection using injectable and get_it
  - `injector.dart` - DI configuration entry point
  - `module.dart` - Module registrations

### Key Patterns

1. **Dependency Injection**: Uses `injectable` with `get_it` for dependency management. Access via `getIt<Type>()`.

2. **State Management**: BLoC pattern throughout. Global state (auth, settings, profile) is provided at app level in `app.dart`.

3. **Navigation**: Uses `auto_route` for type-safe routing. Router defined in `lib/core/component/router/app_router.dart`.

4. **Code Generation**: Heavily relies on code generation for models (freezed), JSON serialization (json_serializable), DI (injectable), and routing (auto_route).

5. **Responsive Design**: Uses `responsive_framework` for multi-device support (mobile, tablet, desktop).

6. **Workspace**: Monorepo structure with workspace packages in `packages/`:
   - `ya_summary` - YandexGPT integration for article summaries
   - `flutter_highlight` - Custom syntax highlighting
   - `quick_shortcuts` - Wrapper for quick_actions library (home screen shortcuts)

### Authentication Flow

The app implements a WebView-based authentication system (`lib/presentation/widget/auth/login_webview.dart`) that supports both direct login and OAuth providers.

**Authentication Methods:**
1. **Direct Form Login** - User logs in via Habr's login form at `${Urls.siteApiUrl}/v1/auth/habrahabr/?back=/ru/all`
2. **OAuth Providers** - Third-party authentication via GitHub, Google, VK, Yandex

**Login Flow Logic:**

The `LoginWebView` widget uses `WebViewController` with `NavigationDelegate` to intercept URLs and handle authentication:

- **Direct Login** (`/ru/all` with no parameters):
  - Extract cookies via `WebviewCookieManager`
  - Save cookies to `TokenRepository.cookieJar`
  - Extract `sid` token and pass to `LoginCubit.handle()`

- **OAuth with intermediate redirect** (`/ru/all?code=X`):
  - Allow navigation to continue (intermediate OAuth step)
  - Do NOT process cookies yet

- **OAuth complete** (`/ru/all?code=X&state=Y`):
  - Both `code` and `state` parameters present
  - Extract cookies and process authentication
  - Pass token to `LoginCubit.handle()`

**Security:**
- Navigation restricted to whitelisted domains via `_allowedOAuthDomains` constant
- Habr domains (`habr.com`, `account.habr.com`) always allowed
- OAuth providers: GitHub, Google, VK, Yandex

**State Management:**
- `LoginCubit` manages authentication state with `LoadingStatus` enum
- UI reacts to state changes via `BlocListener`
- Successful login triggers `Navigator.pop()` to close the WebView

**Important Notes:**
- Cookies are saved to both `Urls.baseUrl` and `Urls.mobileBaseUrl` for API compatibility

### Application Initialization Structure

The `lib/presentation/app/` directory contains the application initialization and configuration system with the following structure:

**`app/app.dart`** - Main entry point widget
- `Application` class orchestrates the complete app widget hierarchy
- Builds layers in strict order: DevicePreview → AppConfigProvider → GlobalBlocProvider → GlobalBlocListener → AppBootstrap → ApplicationView
- Uses `AppConfig.dev` for debug mode, `AppConfig.prod` for release

**`app/config/`** - Application configuration
- `app_config.dart` - Centralized configuration using freezed
  - `AppConfig.dev` - Development config (enables DevicePreview)
  - `AppConfig.prod` - Production config (3 second splash screen)
  - Properties: `enableDevicePreview`, `textScaleFactor`, `responsiveBreakpoints`, `maxWidth`, `splashMinDuration`
- `app_config_provider.dart` - InheritedWidget для доступа к конфигурации через `AppConfigProvider.of(context)`

**`app/bootstrap/`** - Application initialization management
- `app_bootstrap.dart` - Controls app initialization and splash screen display
  - Monitors critical BLoCs: `SettingsCubit`, `AuthCubit`
  - Displays splash screen until all critical BLoCs complete initialization
  - Enforces minimum splash duration if configured in `AppConfig`
  - Shows error screen with retry button if initialization fails
  - Hides splash when: (1) initialization complete AND (2) minimum duration passed

**`app/provider/`** - Global BLoC providers
- `global_bloc_provider.dart` - Creates all global app-level BLoCs
  - `SettingsCubit` (lazy: false) - App settings, initialized immediately
  - `AuthCubit` (lazy: false) - Authentication state, initialized immediately
  - `SummaryAuthCubit` (lazy: false) - YandexGPT auth, initialized immediately
  - `ProfileBloc` (lazy: false) - User profile
  - `PublicationBookmarksBloc` (lazy: true) - Publication bookmarks, loaded on demand

**`app/coordinator/`** - Inter-BLoC coordination logic
- `global_bloc_listener.dart` - Centralizes coordination between global BLoCs
  - Listens to `AuthCubit` state changes
  - On `AuthStatus.authorized`: triggers `ProfileBloc` to fetch user profile and updates
  - On `AuthStatus.unauthorized`: resets `ProfileBloc` state
  - Initializes `ShortcutsManager` after changing `ProfileState` `UserMe` model
  - All cross-BLoC coordination should be added here

**`app/view/`** - Core application views
- `application_view.dart` - Main MaterialApp widget with routing and theming
- `splash_screen.dart` - Splash screen displayed during initialization

**Widget Hierarchy:**
```
Application
├── DevicePreview (dev only)
└── AppConfigProvider (provides AppConfig via InheritedWidget)
    └── GlobalBlocProvider (creates all global BLoCs)
        └── GlobalBlocListener (coordinates BLoC interactions)
            └── AppBootstrap (manages initialization & splash)
                └── ApplicationView (MaterialApp with routing)
```

### Quick Shortcuts Component

The `lib/core/component/shortcuts/` directory provides infrastructure for home screen quick actions (shortcuts).

**`shortcuts/shortcuts_manager.dart`** - Singleton service managing quick actions
- Registered in DI with `@singleton`
- Depends on `AppRouter` for navigation and `UserMe` for user-specific shortcuts
- `init(UserMe user)` - initializes shortcuts with current user context
- Handles shortcut tap events and routes to appropriate screens via `_getRouteForAction()`
- Filters user-specific shortcuts (bookmarks) for unauthorized users using `isUserSpecific` list
- Error handling with logging through `logger` component

**`shortcuts/shortcut_action.dart`** - Enum defining available shortcuts
- `ShortcutAction.bookmarks` → `UserDashboardRoute` (requires authorization)
- `ShortcutAction.articles` → `ArticlesFlowRoute`
- `ShortcutAction.posts` → `PostsFlowRoute`
- `ShortcutAction.news` → `NewsFlowRoute`
- `ShortcutAction.search` → `SearchAnywhereRoute`
- Pure value object - stores only metadata (id, title)
- Type-safe ID parsing via `fromId(String id)` method

**Integration:**
- Initialized in `GlobalBlocListener` when `ProfileBloc.state.me` changes
- Reactive: automatically updates shortcuts on login/logout via `listenWhen: (prev, curr) => prev.me != curr.me || curr.me.isEmpty`
- Uses `quick_shortcuts` package (located in `packages/quick_shortcuts`)
- Follows same pattern as other core components (router, logger, storage)

**Architecture:**
- Enum stores only metadata (follows value object pattern)
- All navigation logic in `ShortcutsManager` (access to dependencies)
- User context passed as parameter, not injected (clean dependency flow)

**Why `core/component/`?**
- Infrastructure service without UI or business logic
- Singleton managing platform capabilities (like `AppRouter`)
- Stateless service initialized at app level
- Not a feature module (no Cubit/UI components)

## Development Commands

**IMPORTANT**: This project uses FVM (Flutter Version Manager) to manage Flutter versions. All `flutter` and `dart` commands must be executed through the `.fvm/flutter_sdk/bin/` path.

### Setup

```bash
# Get dependencies
.fvm/flutter_sdk/bin/flutter pub get

# Generate code (models, DI, routing)
.fvm/flutter_sdk/bin/flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for code generation during development
.fvm/flutter_sdk/bin/flutter pub run build_runner watch --delete-conflicting-outputs
```

### Code Generation Utilities

```bash
# Show available commands
sh scripts/runner.sh

# Generate code (models, DI, routing)
sh scripts/runner.sh --build

# Generate app icons
sh scripts/runner.sh --icons

# Generate splash screen
sh scripts/runner.sh --splash
```

### Environment Configuration

Create `.env.prod` file based on `.env.example` before building:
```
ENV=prod
CONTACT_EMAIL=your@email.com
CONTACT_TG=your_telegram
```

### Build & Run

```bash
# Development run
.fvm/flutter_sdk/bin/flutter run

# Build APK (production)
sh scripts/build.sh env=prod

# Build without running code generation
sh scripts/build.sh env=prod --no-runner

# Build options:
#   env=prod|dev - defines build environment
#   --no-runner - skip build_runner execution
```

### Version Management

```bash
# Show available commands
sh scripts/version.sh

# Increment patch version and build number (e.g., 1.2.4+10703 -> 1.2.5+10704)
sh scripts/version.sh --up

# Increment only build number (e.g., 1.2.4+10703 -> 1.2.4+10704)
sh scripts/version.sh --build

# Install and update Flutter version from FVM
# This command:
# 1. Installs the specified Flutter version via fvm install
# 2. Updates .fvmrc with the new version
# 3. Updates pubspec.yaml environment.flutter field
sh scripts/version.sh flutter=3.35.6
```

### Testing & Linting

```bash
# Run linter
.fvm/flutter_sdk/bin/flutter analyze

# Format code (preserves trailing commas)
.fvm/flutter_sdk/bin/dart format .
```

### Deeplink Testing

```bash
# Android
adb shell am start -a android.intent.action.VIEW -d "<URI>"

# iOS Simulator
/usr/bin/xcrun simctl openurl booted "<URI>"
```

## Code Style Guidelines

### Linting Rules (from analysis_options.yaml)

- Use single quotes for strings
- Prefer relative imports within lib/
- Prefer const constructors where possible
- Always declare return types
- Use super parameters
- Generated files (*.g.dart, *.gr.dart, *.freezed.dart, *.config.dart) are excluded from analysis

### Documentation Comments

- **Important**: Use triple-slash `///` for documentation comments (Dart convention)
- Write comments in Russian, but keep technical terms and service names (OAuth, GitHub, etc.) in their original language

### BLoC/Cubit Conventions

- States use freezed for immutability
- Events use freezed unions for different actions
- Business logic should never directly access UI layer
- Use repositories for data access, not services directly

**Important Notes:**
- Always use the shared `LoadingStatus` enum from `lib/data/model/loading_status_enum.dart` for operation status tracking instead of creating custom status enums. It provides standard states: `initial`, `loading`, `success`, `failure`
- Never use `await` when calling Cubit/Bloc methods from UI. Call methods without await (fire-and-forget), and use `BlocListener` or `BlocBuilder` to react to state changes. This prevents race conditions where the Cubit might be closed before the awaited method completes.
- UI components should react to state changes via `BlocListener` or `BlocBuilder`

### Code Generation Requirements

After modifying models, DI annotations, or routes, always run:
```bash
.fvm/flutter_sdk/bin/flutter pub run build_runner build --delete-conflicting-outputs
```

Files requiring code generation have corresponding `.g.dart`, `.freezed.dart`, or `.gr.dart` files.

## Git Workflow

- **Main branch**: `master`
- Commit messages are in Russian and in lowercase (follow existing pattern)
- Make commit only if explicitly requested by a user

## Common Tasks

### Adding a New Feature

1. Create feature module in `lib/feature/<feature_name>/`
2. Create BLoC/Cubit in `lib/bloc/<feature_name>/`
3. Add data models in `lib/data/model/<feature_name>/`
4. Register dependencies in DI with `@injectable` annotations
5. Run `build_runner` to generate code
6. Add pages/widgets in `lib/presentation/`
7. Register routes in router if needed

### Adding a New API Endpoint

1. Add method to appropriate service in `lib/data/service/`
2. Create/update models with freezed and json_serializable
3. Add repository method in `lib/data/repository/`
4. Register in DI if new service
5. Run `build_runner`

### Modifying State Management

1. Update state classes in `lib/bloc/<feature>/`
2. Run `build_runner` to regenerate freezed code
3. Update BLoC/Cubit event handlers
4. Update UI to reflect state changes