# Development Commands

← [Back to CLAUDE.md](../../CLAUDE.md)

## FVM (Flutter Version Manager)

**IMPORTANT**: This project uses FVM to manage Flutter versions. All `flutter` and `dart` commands must be executed through the `.fvm/flutter_sdk/bin/` path.

## Setup Commands

### Install Dependencies

```bash
# Get all dependencies
.fvm/flutter_sdk/bin/flutter pub get

# Get dependencies for workspace packages
cd packages/ya_summary && .fvm/flutter_sdk/bin/flutter pub get
cd packages/quick_shortcuts && .fvm/flutter_sdk/bin/flutter pub get
cd packages/flutter_highlight && .fvm/flutter_sdk/bin/flutter pub get
```

### Initial Setup

```bash
# 1. Install dependencies
.fvm/flutter_sdk/bin/flutter pub get

# 2. Generate code
.fvm/flutter_sdk/bin/flutter pub run build_runner build --delete-conflicting-outputs

# 3. Create environment file
cp .env.example .env.prod
# Edit .env.prod with your values
```

## Code Generation

### build_runner

Code generation for models, DI, and routing.

```bash
# Generate code once
.fvm/flutter_sdk/bin/flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (recommended for development)
.fvm/flutter_sdk/bin/flutter pub run build_runner watch --delete-conflicting-outputs

# Clean generated files and rebuild
.fvm/flutter_sdk/bin/flutter pub run build_runner clean
.fvm/flutter_sdk/bin/flutter pub run build_runner build --delete-conflicting-outputs
```

**When to Run:**
- After modifying models with `@freezed` or `@JsonSerializable`
- After changing DI annotations (`@injectable`, `@singleton`, etc.)
- After updating routes with `@RoutePage`
- After adding/removing dependencies in DI modules

**Generated Files:**
- `*.g.dart` - JSON serialization
- `*.freezed.dart` - Freezed models
- `*.gr.dart` - Auto route
- `*.config.dart` - Injectable DI

### Script-based Code Generation

```bash
# Show available commands
sh scripts/runner.sh

# Generate code (same as build_runner)
sh scripts/runner.sh --build

# Generate app icons
sh scripts/runner.sh --icons

# Generate splash screen
sh scripts/runner.sh --splash
```

## Environment Configuration

### Environment Files

Create `.env.prod` based on `.env.example`:

```env
ENV=prod
CONTACT_EMAIL=your@email.com
CONTACT_TG=your_telegram
```

**Environment Types:**
- `.env.dev` - Development environment
- `.env.prod` - Production environment

## Build & Run

### Development

```bash
# Run in debug mode
.fvm/flutter_sdk/bin/flutter run

# Run on specific device
.fvm/flutter_sdk/bin/flutter run -d <device_id>

# Run with specific entry point
.fvm/flutter_sdk/bin/flutter run -t lib/main.dart
```

### Build for Production

```bash
# Build APK (production)
sh scripts/build.sh env=prod

# Build without running code generation
sh scripts/build.sh env=prod --no-runner

# Build specific platform
.fvm/flutter_sdk/bin/flutter build apk --release
.fvm/flutter_sdk/bin/flutter build appbundle --release
.fvm/flutter_sdk/bin/flutter build ios --release
.fvm/flutter_sdk/bin/flutter build web --release
```

**Build Script Options:**
- `env=prod|dev` - Defines build environment
- `--no-runner` - Skip build_runner execution

### Platform-Specific Builds

```bash
# Android APK
.fvm/flutter_sdk/bin/flutter build apk --release

# Android App Bundle (for Play Store)
.fvm/flutter_sdk/bin/flutter build appbundle --release

# iOS
.fvm/flutter_sdk/bin/flutter build ios --release

# Web
.fvm/flutter_sdk/bin/flutter build web --release

# Split APKs by ABI
.fvm/flutter_sdk/bin/flutter build apk --split-per-abi
```

## Version Management

### Version Script

```bash
# Show available commands
sh scripts/version.sh

# Increment patch version and build number
# Example: 1.2.4+10703 → 1.2.5+10704
sh scripts/version.sh --up

# Increment only build number
# Example: 1.2.4+10703 → 1.2.4+10704
sh scripts/version.sh --build

# Update Flutter version
# 1. Installs Flutter version via fvm install
# 2. Updates .fvmrc
# 3. Updates pubspec.yaml environment.flutter field
sh scripts/version.sh flutter=3.35.6
```

### Manual Version Update

Edit `pubspec.yaml`:
```yaml
version: 1.2.5+10705
#        ^     ^
#        |     └─ Build number (for stores)
#        └─ Version name (for users)
```

## Testing & Quality

### Linting

```bash
# Run analyzer
.fvm/flutter_sdk/bin/flutter analyze

# Fix auto-fixable issues
.fvm/flutter_sdk/bin/dart fix --apply
```

### Code Formatting

```bash
# Format all files
.fvm/flutter_sdk/bin/dart format .

# Format specific file
.fvm/flutter_sdk/bin/dart format lib/path/to/file.dart

# Check formatting without applying
.fvm/flutter_sdk/bin/dart format --output=none --set-exit-if-changed .
```

### Testing

```bash
# Run all tests
.fvm/flutter_sdk/bin/flutter test

# Run specific test file
.fvm/flutter_sdk/bin/flutter test test/path/to/test.dart

# Run with coverage
.fvm/flutter_sdk/bin/flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
```

## Deeplink Testing

### Android

```bash
# Test deeplink on Android
adb shell am start -a android.intent.action.VIEW -d "<URI>"

# Example: Open article
adb shell am start -a android.intent.action.VIEW -d "https://habr.com/ru/articles/123456/"

# Example: Open user profile
adb shell am start -a android.intent.action.VIEW -d "https://habr.com/ru/users/username/"
```

### iOS Simulator

```bash
# Test deeplink on iOS Simulator
/usr/bin/xcrun simctl openurl booted "<URI>"

# Example: Open article
/usr/bin/xcrun simctl openurl booted "https://habr.com/ru/articles/123456/"

# Example: Open user profile
/usr/bin/xcrun simctl openurl booted "https://habr.com/ru/users/username/"
```

## Device Management

### List Devices

```bash
# List connected devices
.fvm/flutter_sdk/bin/flutter devices

# List emulators
.fvm/flutter_sdk/bin/flutter emulators

# Launch emulator
.fvm/flutter_sdk/bin/flutter emulators --launch <emulator_id>
```

### Device Logs

```bash
# View logs
.fvm/flutter_sdk/bin/flutter logs

# Clear logs
adb logcat -c  # Android
```

## Dependency Management

### Update Dependencies

```bash
# Update dependencies to latest compatible versions
.fvm/flutter_sdk/bin/flutter pub upgrade

# Update specific package
.fvm/flutter_sdk/bin/flutter pub upgrade <package_name>

# Get outdated packages
.fvm/flutter_sdk/bin/flutter pub outdated
```

### Analyze Dependencies

```bash
# Show dependency tree
.fvm/flutter_sdk/bin/flutter pub deps

# Show dependency tree in compact format
.fvm/flutter_sdk/bin/flutter pub deps --style=compact

# Find why a package is used
.fvm/flutter_sdk/bin/flutter pub deps | grep <package_name>
```

## Clean & Reset

### Clean Build Artifacts

```bash
# Clean build files
.fvm/flutter_sdk/bin/flutter clean

# Remove generated files
find . -name "*.g.dart" -delete
find . -name "*.freezed.dart" -delete
find . -name "*.gr.dart" -delete
find . -name "*.config.dart" -delete

# Full reset
.fvm/flutter_sdk/bin/flutter clean
rm -rf .dart_tool/
rm pubspec.lock
.fvm/flutter_sdk/bin/flutter pub get
```

### Reset Build Runner

```bash
# Clean build_runner cache
.fvm/flutter_sdk/bin/flutter pub run build_runner clean

# Rebuild everything
.fvm/flutter_sdk/bin/flutter pub run build_runner build --delete-conflicting-outputs
```

## Performance & Debugging

### Performance Profiling

```bash
# Run with performance overlay
.fvm/flutter_sdk/bin/flutter run --profile

# Open DevTools
.fvm/flutter_sdk/bin/flutter pub global activate devtools
.fvm/flutter_sdk/bin/flutter pub global run devtools
```

### Debug Commands

```bash
# Run in debug mode with verbose logging
.fvm/flutter_sdk/bin/flutter run --verbose

# Attach to running app
.fvm/flutter_sdk/bin/flutter attach

# Hot reload
# Press 'r' in terminal during flutter run

# Hot restart
# Press 'R' in terminal during flutter run
```

## Workspace Commands

### Working with Packages

```bash
# Generate code for specific package
cd packages/ya_summary
.fvm/flutter_sdk/bin/flutter pub run build_runner build --delete-conflicting-outputs

# Test specific package
cd packages/quick_shortcuts
.fvm/flutter_sdk/bin/flutter test

# Analyze specific package
cd packages/flutter_highlight
.fvm/flutter_sdk/bin/flutter analyze
```

## Common Workflows

### Starting Development

```bash
# 1. Get dependencies
.fvm/flutter_sdk/bin/flutter pub get

# 2. Generate code in watch mode
.fvm/flutter_sdk/bin/flutter pub run build_runner watch --delete-conflicting-outputs

# 3. In another terminal, run the app
.fvm/flutter_sdk/bin/flutter run
```

### Preparing for Commit

```bash
# 1. Format code
.fvm/flutter_sdk/bin/dart format .

# 2. Run analyzer
.fvm/flutter_sdk/bin/flutter analyze

# 3. Run tests
.fvm/flutter_sdk/bin/flutter test

# 4. Generate code (ensure up to date)
.fvm/flutter_sdk/bin/flutter pub run build_runner build --delete-conflicting-outputs
```

### Release Build

```bash
# 1. Update version
sh scripts/version.sh --up

# 2. Generate code
.fvm/flutter_sdk/bin/flutter pub run build_runner build --delete-conflicting-outputs

# 3. Build release
sh scripts/build.sh env=prod
```

## Troubleshooting

### Common Issues

**Issue:** "command not found: flutter"
```bash
# Solution: Use FVM path
.fvm/flutter_sdk/bin/flutter --version
```

**Issue:** Build failures after dependency update
```bash
# Solution: Clean and regenerate
.fvm/flutter_sdk/bin/flutter clean
.fvm/flutter_sdk/bin/flutter pub get
.fvm/flutter_sdk/bin/flutter pub run build_runner build --delete-conflicting-outputs
```

**Issue:** "Conflicts" during build_runner
```bash
# Solution: Use --delete-conflicting-outputs flag
.fvm/flutter_sdk/bin/flutter pub run build_runner build --delete-conflicting-outputs
```

## Related Documentation

- [Code Style](code-style.md) - Code style guidelines
- [Common Tasks](common-tasks.md) - Common development tasks
- [Architecture Overview](../architecture/overview.md) - Project architecture

---

← [Back to CLAUDE.md](../../CLAUDE.md)
