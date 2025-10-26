# Presentation Layer

← [Back to Overview](overview.md) | [Core Components](core-components.md)

## Application Initialization Structure

The `lib/presentation/app/` directory contains the application initialization and configuration system.

## Directory Structure

```
lib/presentation/app/
├── app.dart              # Main entry point widget
├── config/               # Application configuration
│   ├── app_config.dart
│   └── app_config_provider.dart
├── bootstrap/            # Application initialization
│   └── app_bootstrap.dart
├── provider/             # Global BLoC providers
│   └── global_bloc_provider.dart
├── coordinator/          # Inter-BLoC coordination
│   └── global_bloc_listener.dart
└── view/                 # Core application views
    ├── application_view.dart
    └── splash_screen.dart
```

## Components

### app.dart - Main Entry Point

**Location:** `lib/presentation/app/app.dart`

The `Application` class orchestrates the complete app widget hierarchy.

**Features:**
- Builds layers in strict order
- Environment-based configuration (dev/prod)
- Device preview support for development

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

**Configuration:**
- Debug mode: Uses `AppConfig.dev`
- Release mode: Uses `AppConfig.prod`

### config/ - Application Configuration

**Location:** `lib/presentation/app/config/`

#### app_config.dart

Centralized configuration using freezed.

**Configurations:**

**AppConfig.dev** - Development configuration:
- Enables DevicePreview
- Custom text scale factor
- Development-specific breakpoints
- No minimum splash duration

**AppConfig.prod** - Production configuration:
- DevicePreview disabled
- Production breakpoints
- 3-second minimum splash screen duration

**Properties:**
- `enableDevicePreview` - Toggle device preview
- `textScaleFactor` - Text scaling
- `responsiveBreakpoints` - Responsive framework breakpoints
- `maxWidth` - Maximum content width
- `splashMinDuration` - Minimum splash screen duration

#### app_config_provider.dart

InheritedWidget providing access to configuration.

**Usage:**
```dart
// Access configuration
final config = AppConfigProvider.of(context);
```

### bootstrap/ - Application Initialization

**Location:** `lib/presentation/app/bootstrap/`

#### app_bootstrap.dart

Controls app initialization and splash screen display.

**Responsibilities:**
- Monitors critical BLoCs initialization
- Displays splash screen during initialization
- Enforces minimum splash duration
- Handles initialization errors

**Critical BLoCs Monitored:**
- `SettingsCubit` - App settings
- `AuthCubit` - Authentication state

**Initialization Flow:**
1. Display splash screen
2. Wait for critical BLoCs to initialize
3. Enforce minimum splash duration (if configured)
4. Hide splash when both conditions met:
   - All critical BLoCs initialized
   - Minimum duration elapsed

**Error Handling:**
- Shows error screen with retry button on failure
- Logs initialization errors
- Allows user to retry initialization

### provider/ - Global BLoC Providers

**Location:** `lib/presentation/app/provider/`

#### global_bloc_provider.dart

Creates all global app-level BLoCs.

**Global BLoCs:**

**Immediate Initialization (lazy: false):**
- `SettingsCubit` - App settings and preferences
- `AuthCubit` - Authentication state
- `SummaryAuthCubit` - YandexGPT authentication
- `ProfileBloc` - User profile data

**Lazy Initialization (lazy: true):**
- `PublicationBookmarksBloc` - Publication bookmarks (loaded on demand)

**Usage:**
```dart
// Access global BLoC
final authCubit = context.read<AuthCubit>();
```

### coordinator/ - Inter-BLoC Coordination

**Location:** `lib/presentation/app/coordinator/`

#### global_bloc_listener.dart

Centralizes coordination between global BLoCs.

**Responsibilities:**
- Listens to `AuthCubit` state changes
- Coordinates cross-BLoC interactions
- Initializes platform services

**Coordination Logic:**

**On AuthStatus.authorized:**
- Triggers `ProfileBloc.fetchProfile()` to fetch user profile
- Waits for profile to load

**On AuthStatus.unauthorized:**
- Resets `ProfileBloc` state
- Clears user-specific data

**On ProfileState changes:**
- Listens when `prev.me != curr.me || curr.me.isEmpty`
- Initializes `ShortcutsManager` with current user
- Updates quick shortcuts based on user context

**Why Centralized Coordination?**
- Prevents circular dependencies
- Single source of truth for cross-BLoC logic
- Easy to test and maintain
- Clear visibility of BLoC interactions

**Adding New Coordination:**
All new cross-BLoC coordination should be added here, not in individual BLoCs.

### view/ - Core Application Views

**Location:** `lib/presentation/app/view/`

#### application_view.dart

Main MaterialApp widget with routing and theming.

**Features:**
- Auto-route integration
- Theme management (light/dark)
- Localization setup
- Responsive framework integration

#### splash_screen.dart

Splash screen displayed during initialization.

**Features:**
- App logo/branding
- Loading indicator
- Minimum display duration support

## Initialization Sequence

```
1. main() -> runApp(Application)
2. Application builds widget tree
3. AppConfigProvider provides configuration
4. GlobalBlocProvider creates BLoCs
5. GlobalBlocListener starts coordination
6. AppBootstrap monitors initialization
7. Splash screen displayed
8. Critical BLoCs initialize
9. Minimum duration enforced
10. ApplicationView revealed
```

## Best Practices

### When to Add New Global BLoC

Add BLoC to `GlobalBlocProvider` if:
- Needed across multiple features
- Manages global state (auth, settings, etc.)
- Needs to be available throughout app lifecycle

Use local BLoC if:
- Feature-specific state
- Short lifecycle (screen-level)
- Not shared across features

### When to Add Coordination Logic

Add to `GlobalBlocListener` if:
- One BLoC needs to react to another's state
- Cross-feature coordination required
- Platform service initialization needed

Keep in individual BLoC if:
- Internal state transitions
- Feature-specific logic
- No cross-BLoC dependencies

## Related Documentation

- [Architecture Overview](overview.md) - Overall architecture
- [Core Components](core-components.md) - Infrastructure components
- [App Initialization Flow](../flows/app-initialization.md) - Detailed bootstrap process
- [Development Commands](../development/commands.md) - Development workflow

---

← [Back to Overview](overview.md) | [Core Components](core-components.md)
