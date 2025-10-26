# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Project Overview

Flabr is an unofficial mobile client for habr.com built with Flutter. It supports Android, iOS, and Web platforms with features including dark/light themes, authorization, feed customization, and AI-powered article summaries using YandexGPT.

**Architecture**: Clean Architecture with BLoC pattern
**Key Technologies**: Flutter 3.35.6, auto_route, injectable/get_it, freezed

## Quick Reference

- **Architecture Details**: [docs/architecture/overview.md](docs/architecture/overview.md)
- **Development Commands**: [docs/development/commands.md](docs/development/commands.md)
- **Code Style**: [docs/development/code-style.md](docs/development/code-style.md)
- **Common Tasks**: [docs/development/common-tasks.md](docs/development/common-tasks.md)

## Critical Instructions

**IMPORTANT**: This project uses FVM (Flutter Version Manager). All `flutter` and `dart` commands must be executed through `.fvm/flutter_sdk/bin/` path.

### Code Generation

After modifying models, DI annotations, or routes, always run:
```bash
.fvm/flutter_sdk/bin/flutter pub run build_runner build --delete-conflicting-outputs
```

### BLoC/Cubit Usage

- **Never use `await`** when calling Cubit/Bloc methods from UI
- Call methods without await (fire-and-forget)
- Use `BlocListener` or `BlocBuilder` to react to state changes
- Always use shared `LoadingStatus` enum from `lib/data/model/loading_status_enum.dart`

### Documentation Comments

- Use triple-slash `///` for documentation comments (Dart convention)
- Write comments in Russian, keep technical terms in their original language

## Key Patterns

1. **Dependency Injection**: `injectable` + `get_it` → Access via `getIt<Type>()`
2. **State Management**: BLoC pattern throughout → Global state provided at app level
3. **Navigation**: `auto_route` for type-safe routing
4. **Code Generation**: freezed, json_serializable, injectable, auto_route
5. **Responsive Design**: `responsive_framework` for multi-device support

## Project Structure

```
lib/
├── bloc/              # Business logic (BLoC/Cubit)
├── data/              # Data layer (models, repositories, services)
├── presentation/      # Presentation layer (pages, widgets, themes)
│   └── app/          # App initialization & configuration
├── feature/          # Self-contained feature modules (with cubit + widgets)
├── core/             # Core infrastructure
│   └── component/    # Shared components (router, logger, shortcuts, http, storage)
└── di/               # Dependency injection setup

packages/
├── quick_shortcuts/   # Wrapper for quick_actions library
├── ya_summary/       # YandexGPT integration
└── flutter_highlight/ # Custom syntax highlighting
```

## Git Workflow

- **Main branch**: `master`
- Commit messages in Russian, lowercase
- Make commits only when explicitly requested by user

## Documentation

For detailed information, see:
- **Architecture**: [docs/architecture/](docs/architecture/) - Clean architecture, layers, components
- **Flows**: [docs/flows/](docs/flows/) - Authentication, app initialization
- **Development**: [docs/development/](docs/development/) - Commands, code style, tasks
- **Packages**: [docs/packages/](docs/packages/) - Workspace packages info
