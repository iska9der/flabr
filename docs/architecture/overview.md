# Architecture Overview

← [Back to CLAUDE.md](../../CLAUDE.md) | [Core Components](core-components.md) | [Presentation Layer](presentation-layer.md)

## Clean Architecture Pattern

The project follows a clean architecture pattern with clear separation of concerns:

## Core Structure

### `lib/bloc/` - Business Logic Layer

Business logic layer using BLoC pattern (flutter_bloc).

**Feature-specific BLoCs and Cubits:**
- `auth/` - Authentication and authorization
- `profile/` - User profile management
- `publication/` - Publication (articles, posts, news) management
- `user/` - User-related functionality
- `company/` - Company profiles
- `hub/` - Hub (topic) management
- `search/` - Search functionality
- `settings/` - App settings
- `tracker/` - Analytics and tracking

**Naming Convention:**
- BLoCs: `<feature>_bloc.dart` with corresponding state/event files
- Cubits: `<feature>_cubit.dart` with corresponding state file

### `lib/data/` - Data Layer

Data layer handling all data operations.

**Structure:**
- `model/` - Data models using freezed and json_serializable for code generation
- `repository/` - Repository implementations for data access (clean architecture principle)
- `service/` - API clients and service implementations
- `exception/` - Custom exception definitions

### `lib/presentation/` - Presentation Layer

UI layer with screens and widgets.

**Structure:**
- `app/` - Application initialization and configuration (see [Presentation Layer](presentation-layer.md))
- `page/` - Screen implementations organized by feature
- `widget/` - Reusable widgets
- `theme/` - Theme configuration and styling
- `extension/` - Dart/Flutter extensions

### `lib/feature/` - Self-contained Feature Modules

Each feature module contains its own cubit, widgets, and models.

**Features:**
- `image_action/` - Image handling actions
- `most_reading/` - Most read articles
- `profile_subscribe/` - Profile subscription functionality
- `publication_download/` - Publication download management
- `publication_list/` - Publication listing components
- `scaffold/` - Custom scaffold implementations
- `scroll/` - Custom scroll behaviors

### `lib/core/` - Core Infrastructure

Core utilities and infrastructure components.

**Structure:**
- `component/` - Shared components (see [Core Components](core-components.md))
  - `http/` - HTTP client configuration
  - `storage/` - Local storage management
  - `router/` - Navigation routing
  - `logger/` - Logging system
  - `shortcuts/` - Quick shortcuts manager
- `constants/` - App-wide constants
- `helper/` - Utility functions

### `lib/di/` - Dependency Injection

Dependency injection using injectable and get_it.

**Structure:**
- `injector.dart` - DI configuration entry point
- `module.dart` - Module registrations

## Key Patterns

### 1. Dependency Injection

Uses `injectable` with `get_it` for dependency management.

**Usage:**
```dart
// Access dependencies
final myService = getIt<MyService>();
```

**Registration:**
```dart
@injectable
class MyService {
  // ...
}
```

### 2. State Management

BLoC pattern throughout the application.

- Global state (auth, settings, profile) provided at app level in `lib/presentation/app/app.dart`
- Feature-specific state managed by feature BLoCs/Cubits
- UI reacts to state changes via `BlocListener` and `BlocBuilder`

### 3. Navigation

Uses `auto_route` for type-safe routing.

- Router defined in `lib/core/component/router/router.dart`
- Routes generated via code generation
- Type-safe navigation with compile-time checking

### 4. Code Generation

Heavily relies on code generation for:
- **Models**: freezed (immutable data classes)
- **JSON Serialization**: json_serializable
- **DI**: injectable (dependency registration)
- **Routing**: auto_route (route generation)

### 5. Responsive Design

Uses `responsive_framework` for multi-device support (mobile, tablet, desktop).

### 6. Workspace Structure

Monorepo with workspace packages in `packages/`:
- `ya_summary/` - YandexGPT integration for article summaries
- `flutter_highlight/` - Custom syntax highlighting
- `quick_shortcuts/` - Wrapper for quick_actions library (home screen shortcuts)

## Project Structure Visualization

```
lib/
├── bloc/              # Business logic (BLoC/Cubit)
│   ├── auth/
│   ├── profile/
│   ├── publication/
│   └── ...
├── data/              # Data layer
│   ├── model/
│   ├── repository/
│   ├── service/
│   └── exception/
├── presentation/      # Presentation layer
│   ├── app/          # App initialization & config
│   ├── page/         # Screens
│   ├── widget/       # Reusable widgets
│   ├── theme/        # Theming
│   └── extension/    # Extensions
├── feature/          # Self-contained features
│   ├── image_action/
│   ├── most_reading/
│   └── ...
├── core/             # Core infrastructure
│   ├── component/    # Shared components
│   ├── constants/
│   └── helper/
└── di/               # Dependency injection
    ├── injector.dart
    └── module.dart

packages/
├── quick_shortcuts/   # Quick actions wrapper
├── ya_summary/        # YandexGPT integration
└── flutter_highlight/ # Syntax highlighting
```

## Related Documentation

- [Core Components](core-components.md) - Detailed description of core infrastructure components
- [Presentation Layer](presentation-layer.md) - Application initialization and UI structure
- [Authentication Flow](../flows/authentication.md) - Authentication system details
- [App Initialization](../flows/app-initialization.md) - Bootstrap process
- [Development Commands](../development/commands.md) - Development workflow

---

← [Back to CLAUDE.md](../../CLAUDE.md) | [Core Components](core-components.md) | [Presentation Layer](presentation-layer.md)
