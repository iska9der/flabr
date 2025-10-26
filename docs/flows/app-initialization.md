# App Initialization Flow

← [Back to CLAUDE.md](../../CLAUDE.md) | [Authentication Flow](authentication.md)

## Overview

The app initialization process is managed by `AppBootstrap` component, which ensures all critical BLoCs are initialized before revealing the main app UI.

**Implementation:** `lib/presentation/app/bootstrap/app_bootstrap.dart`

## Initialization Sequence

### 1. Application Start

```
main()
  → runApp(Application)
  → Application widget builds
```

### 2. Widget Tree Construction

```
Application
├── DevicePreview (dev only)
└── AppConfigProvider
    └── GlobalBlocProvider
        └── GlobalBlocListener
            └── AppBootstrap ← Initialization controller
                └── ApplicationView (hidden until ready)
```

### 3. BLoC Initialization

**GlobalBlocProvider** creates all global BLoCs:

**Immediate (lazy: false):**
1. `SettingsCubit` - Loads app settings from storage
2. `AuthCubit` - Checks authentication status
3. `SummaryAuthCubit` - YandexGPT authentication
4. `ProfileBloc` - User profile (awaits auth)

**Lazy (lazy: true):**
- `PublicationBookmarksBloc` - Loaded on demand

### 4. Bootstrap Monitoring

**AppBootstrap** monitors critical BLoCs:
- `SettingsCubit`
- `AuthCubit`

**Waiting Logic:**
```dart
final isInitialized = settingsCubit.state.status != LoadingStatus.loading
    && authCubit.state.status != LoadingStatus.loading;
```

### 5. Splash Screen Display

**Conditions:**
- Display while `isInitialized == false`
- Enforce minimum duration if configured (production: 3 seconds)

**Logic:**
```dart
final minDurationElapsed = elapsed >= config.splashMinDuration;
final showSplash = !isInitialized || !minDurationElapsed;
```

### 6. Coordination

**GlobalBlocListener** coordinates BLoC interactions:

**On AuthStatus.authorized:**
1. Trigger `ProfileBloc.fetchProfile()`
2. Wait for profile to load
3. Initialize `ShortcutsManager` with user

**On AuthStatus.unauthorized:**
1. Reset `ProfileBloc` state
2. Clear user-specific data

### 7. App Reveal

When both conditions met:
- All critical BLoCs initialized (`isInitialized == true`)
- Minimum duration elapsed (`minDurationElapsed == true`)

Then:
- Hide splash screen
- Reveal `ApplicationView` (MaterialApp)
- App is ready for interaction

## Detailed Component Roles

### AppBootstrap

**Responsibilities:**
- Monitor BLoC initialization status
- Display/hide splash screen
- Enforce minimum splash duration
- Handle initialization errors
- Provide retry mechanism

**State Monitoring:**
```dart
BlocBuilder<SettingsCubit, SettingsState>(
  builder: (context, settingsState) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final isReady = settingsState.status != LoadingStatus.loading
            && authState.status != LoadingStatus.loading;

        return isReady ? ApplicationView() : SplashScreen();
      },
    );
  },
)
```

**Minimum Duration:**
```dart
Timer? _minDurationTimer;

@override
void initState() {
  super.initState();
  _minDurationTimer = Timer(config.splashMinDuration, () {
    setState(() {
      _minDurationElapsed = true;
    });
  });
}
```

### GlobalBlocProvider

**Responsibilities:**
- Create all global BLoCs
- Provide BLoCs to widget tree
- Configure lazy loading

**Implementation:**
```dart
MultiBlocProvider(
  providers: [
    BlocProvider(
      create: (context) => getIt<SettingsCubit>()..load(),
      lazy: false,
    ),
    BlocProvider(
      create: (context) => getIt<AuthCubit>()..checkAuth(),
      lazy: false,
    ),
    BlocProvider(
      create: (context) => getIt<ProfileBloc>(),
      lazy: false,
    ),
    BlocProvider(
      create: (context) => getIt<PublicationBookmarksBloc>(),
      lazy: true, // Created on first access
    ),
  ],
  child: GlobalBlocListener(
    child: AppBootstrap(
      child: ApplicationView(),
    ),
  ),
)
```

### GlobalBlocListener

**Responsibilities:**
- Coordinate cross-BLoC interactions
- Initialize platform services
- React to global state changes

**Auth → Profile Coordination:**
```dart
BlocListener<AuthCubit, AuthState>(
  listenWhen: (prev, curr) => prev.status != curr.status,
  listener: (context, authState) {
    final profileBloc = context.read<ProfileBloc>();

    if (authState.status == AuthStatus.authorized) {
      // Fetch user profile
      profileBloc.add(ProfileEvent.fetch());
    } else if (authState.status == AuthStatus.unauthorized) {
      // Clear profile
      profileBloc.add(ProfileEvent.reset());
    }
  },
)
```

**Profile → Shortcuts Coordination:**
```dart
BlocListener<ProfileBloc, ProfileState>(
  listenWhen: (prev, curr) => prev.me != curr.me || curr.me.isEmpty,
  listener: (context, profileState) {
    final shortcutsManager = getIt<ShortcutsManager>();

    if (profileState.me.isNotEmpty) {
      // Initialize shortcuts with user
      shortcutsManager.init(profileState.me);
    } else {
      // Initialize shortcuts without user
      shortcutsManager.init(null);
    }
  },
)
```

## Configuration

### Development Mode

**AppConfig.dev:**
```dart
AppConfig.dev(
  enableDevicePreview: true,
  splashMinDuration: Duration.zero, // No minimum
)
```

**Behavior:**
- DevicePreview enabled
- No minimum splash duration
- Splash hides immediately after initialization

### Production Mode

**AppConfig.prod:**
```dart
AppConfig.prod(
  enableDevicePreview: false,
  splashMinDuration: Duration(seconds: 3), // 3 seconds
)
```

**Behavior:**
- DevicePreview disabled
- 3-second minimum splash duration
- Ensures branding visibility

## Error Handling

### Initialization Failure

**Scenarios:**
- Settings fail to load
- Auth check fails
- Network error during initialization

**Handling:**
```dart
if (state.status == LoadingStatus.failure) {
  return ErrorScreen(
    error: state.error,
    onRetry: () {
      // Retry initialization
      settingsCubit.load();
      authCubit.checkAuth();
    },
  );
}
```

**User Experience:**
- Show error message
- Display retry button
- Log error for debugging

### Timeout Protection

**Problem:** BLoC initialization hangs

**Solution:**
```dart
Future<void> _initializeWithTimeout() async {
  await Future.any([
    _waitForInitialization(),
    Future.delayed(Duration(seconds: 10)).then((_) {
      throw TimeoutException('Initialization timeout');
    }),
  ]);
}
```

## Timeline Example

### Development Mode (No Minimum Duration)

```
0ms:   App starts
50ms:  BLoCs created
100ms: SettingsCubit loads
150ms: AuthCubit checks auth
200ms: Initialization complete
200ms: Splash hides, app reveals ← Immediate
```

### Production Mode (3-Second Minimum)

**Fast Initialization:**
```
0ms:    App starts
50ms:   BLoCs created
100ms:  SettingsCubit loads
150ms:  AuthCubit checks auth
200ms:  Initialization complete (wait for minimum)
3000ms: Minimum duration elapsed
3000ms: Splash hides, app reveals ← Delayed to 3s
```

**Slow Initialization:**
```
0ms:    App starts
50ms:   BLoCs created
100ms:  SettingsCubit loads
3500ms: AuthCubit completes (slow network)
3500ms: Initialization complete (minimum already elapsed)
3500ms: Splash hides, app reveals ← Natural timing
```

## Best Practices

### Adding Critical BLoC

To add a new BLoC to critical initialization:

1. Add to `GlobalBlocProvider` with `lazy: false`
2. Update `AppBootstrap` monitoring logic
3. Ensure BLoC has proper error handling
4. Test initialization failure scenarios

### Coordination Logic

To add new cross-BLoC coordination:

1. Add `BlocListener` to `GlobalBlocListener`
2. Use `listenWhen` to filter relevant state changes
3. Document coordination in code comments
4. Update this documentation

## Debugging

### Enable Logging

```dart
// In SettingsCubit
@override
Future<void> load() async {
  logger.info('Loading settings', title: 'SettingsCubit');
  emit(state.copyWith(status: LoadingStatus.loading));

  try {
    final settings = await repository.load();
    logger.info('Settings loaded', title: 'SettingsCubit');
    emit(state.copyWith(status: LoadingStatus.success, data: settings));
  } catch (e, st) {
    logger.error('Failed to load settings', e, st);
    emit(state.copyWith(status: LoadingStatus.failure, error: e));
  }
}
```

### Monitor Initialization

```dart
// In AppBootstrap
print('Settings: ${settingsState.status}');
print('Auth: ${authState.status}');
print('Initialized: $isInitialized');
print('Min duration elapsed: $minDurationElapsed');
print('Show splash: $showSplash');
```

## Related Documentation

- [Presentation Layer](../architecture/presentation-layer.md) - App structure
- [Authentication Flow](authentication.md) - Auth details
- [Core Components](../architecture/core-components.md) - Infrastructure

---

← [Back to CLAUDE.md](../../CLAUDE.md) | [Authentication Flow](authentication.md)
