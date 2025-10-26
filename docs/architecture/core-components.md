# Core Components

← [Back to Overview](overview.md) | [Presentation Layer](presentation-layer.md)

## Overview

The `lib/core/component/` directory contains shared infrastructure components that provide essential services throughout the application.

## Router Component

**Location:** `lib/core/component/router/`

### AppRouter

Type-safe navigation system using `auto_route` package.

**Key Files:**
- `app_router.dart` - Router configuration and route definitions
- `app_router.gr.dart` - Generated routes (auto-generated, do not edit)

**Features:**
- Declarative routing with `@RoutePage()` annotations
- Type-safe navigation with compile-time checking
- Nested navigation support
- Deep linking support
- Route guards and middlewares

**Usage:**
```dart
// Navigate to a route
context.router.push(PublicationDetailRoute(id: '123'));

// Navigate with replacement
context.router.replace(LoginRoute());

// Pop route
context.router.pop();
```

## Logger Component

**Location:** `lib/core/component/logger/`

Centralized logging system for the application.

**Features:**
- Structured logging
- Log level filtering (info, warning, error)
- Integration with crash reporting
- Development vs production logging modes

**API:**
```dart
// Info messages
logger.info(Object message, {String? title});

// Warnings
logger.warning(Object message, {String? title, StackTrace? stackTrace});

// Errors
logger.error(Object message, Object exception, StackTrace? trace);
```

**Usage:**
```dart
// Simple info
logger.info('User logged in');

// Info with title
logger.info('Session started', title: 'Auth');

// Warning
logger.warning('Low memory', title: 'Performance');

// Warning with stack trace
logger.warning('Connection unstable', title: 'Network', stackTrace: stackTrace);

// Error (exception is required!)
logger.error('Failed to load data', exception, trace);
```

## Shortcuts Component

**Location:** `lib/core/component/shortcuts/`

Infrastructure for home screen quick actions (app shortcuts).

### ShortcutsManager

Singleton service managing quick actions on home screen.

**Key Files:**
- `shortcuts_manager.dart` - Main service implementation
- `shortcut_action.dart` - Enum defining available shortcuts

**Registration:**
```dart
@singleton
class ShortcutsManager {
  // Registered in DI
}
```

**Dependencies:**
- `AppRouter` - For navigation
- `UserMe` - For user-specific shortcuts (passed as parameter)

**Available Shortcuts:**
- `bookmarks` → User Dashboard (requires authorization)
- `articles` → Articles Flow
- `posts` → Posts Flow
- `news` → News Flow
- `search` → Search Anywhere

**Initialization:**
```dart
// Called from GlobalBlocListener when profile state changes
shortcutsManager.init(user);
```

**Architecture Principles:**
- Enum (`ShortcutAction`) stores only metadata (id, title)
- All navigation logic in `ShortcutsManager` (access to dependencies)
- User context passed as parameter, not injected
- Filters user-specific shortcuts for unauthorized users
- Error handling with logging

**Integration:**
- Initialized in `GlobalBlocListener` when `ProfileBloc.state.me` changes
- Reactive: updates on login/logout automatically
- Uses `quick_shortcuts` package from workspace (`packages/quick_shortcuts`)

**Why `core/component/`?**
- Infrastructure service without UI or business logic
- Singleton managing platform capabilities (like `AppRouter`)
- Stateless service initialized at app level
- Not a feature module (no Cubit/UI components)

## HTTP Component

**Location:** `lib/core/component/http/`

HTTP client configuration and networking layer.

**Features:**
- Dio-based HTTP client
- Interceptors for authentication, logging, error handling
- Request/response transformers
- Retry logic
- Timeout configuration

**Configuration:**
- Base URL configuration
- Headers management
- Cookie handling
- SSL certificate pinning (if applicable)

## Storage Component

**Location:** `lib/core/component/storage/`

Local storage management for persistent data.

**Features:**
- Secure storage for sensitive data
- SharedPreferences wrapper
- Key-value storage interface
- Encrypted storage for credentials

**Usage:**
- User preferences
- Authentication tokens
- Cached data
- App settings

## Component Design Principles

All core components follow these principles:

1. **Single Responsibility** - Each component handles one infrastructure concern
2. **Dependency Injection** - Registered in DI container with `@singleton` or `@injectable`
3. **No UI Logic** - Components are UI-agnostic
4. **No Business Logic** - Business logic belongs in BLoCs/Cubits
5. **Stateless** - Components don't maintain feature-specific state
6. **Reusable** - Can be used across different features

## Adding a New Component

When creating a new core component:

1. Create directory in `lib/core/component/<component_name>/`
2. Implement component with clear interface
3. Register in DI with appropriate scope
4. Add error handling and logging
5. Document usage and integration
6. Update this documentation

## Related Documentation

- [Architecture Overview](overview.md) - Overall architecture
- [Presentation Layer](presentation-layer.md) - Application initialization
- [Development Commands](../development/commands.md) - Development workflow

---

← [Back to Overview](overview.md) | [Presentation Layer](presentation-layer.md)
