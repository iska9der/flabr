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
  - `page/` - Screen implementations organized by feature
  - `widget/` - Reusable widgets
  - `theme/` - Theme configuration and styling
  - `extension/` - Dart/Flutter extensions
  - `app.dart` - Main application widget

- **`lib/feature/`** - Self-contained feature modules
  - Each feature contains its own cubit, widgets, and models
  - Features: image_action, most_reading, profile_subscribe, publication_download, publication_list, scaffold, scroll

- **`lib/core/`** - Core utilities and infrastructure
  - `component/` - Shared components (http, storage, router, logger)
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

## Development Commands

### Setup

```bash
# Get dependencies
flutter pub get

# Generate code (models, DI, routing)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for code generation during development
flutter pub run build_runner watch --delete-conflicting-outputs
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
flutter run

# Build APK (production)
sh scripts/build.sh env=prod

# Build without running code generation
sh scripts/build.sh env=prod --no-runner

# Build options:
#   env=prod|dev - defines build environment
#   --no-runner - skip build_runner execution
```

### Testing & Linting

```bash
# Run linter
flutter analyze

# Format code (preserves trailing commas)
dart format .
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

### BLoC/Cubit Conventions

- States use freezed for immutability
- Events use freezed unions for different actions
- Business logic should never directly access UI layer
- Use repositories for data access, not services directly

### Code Generation Requirements

After modifying models, DI annotations, or routes, always run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Files requiring code generation have corresponding `.g.dart`, `.freezed.dart`, or `.gr.dart` files.

## Git Workflow

- **Main branch**: `master`
- Commit messages are in Russian (follow existing pattern)

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
