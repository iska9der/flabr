# Development Commands

← [Back to CLAUDE.md](../../CLAUDE.md)

## FVM (Flutter Version Manager)

**IMPORTANT**: This project uses FVM to manage Flutter versions. All `flutter` and `dart` commands must be executed through the `.fvm/flutter_sdk/bin/` path.

## Setup Commands

### Install Dependencies

```bash
# Resolve the app and all workspace packages
.fvm/flutter_sdk/bin/flutter pub get
```

### Initial Setup

```bash
# 1. Install dependencies
.fvm/flutter_sdk/bin/flutter pub get

# 2. Generate code
.fvm/flutter_sdk/bin/flutter pub run build_runner build

# 3. Create environment file
cp .env.example .env.prod
# Edit .env.prod with your values
```

## Code Generation

### build_runner

Code generation for models, DI, and routing.

```bash
# Generate code once
.fvm/flutter_sdk/bin/flutter pub run build_runner build

# Watch mode (recommended for development)
.fvm/flutter_sdk/bin/flutter pub run build_runner watch

# Clean generated files and rebuild
.fvm/flutter_sdk/bin/flutter pub run build_runner clean
.fvm/flutter_sdk/bin/flutter pub run build_runner build
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
sh scripts/version.sh flutter=3.47.3
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

### F-Droid Screenshots

Start an Android emulator or connect a device with USB debugging. The device ID
is required; obtain it from `adb devices`.

```bash
# Capture every configured source locale and scenario
sh scripts/update_screenshots.sh <device-id>

# Capture selected source locale/scenario combinations in the given order
sh scripts/update_screenshots.sh <device-id> \
  --locales <language-a>,<language-b> \
  --scenarios <number-a>,<number-b>

# Current selection example
sh scripts/update_screenshots.sh emulator-5554 \
  --locales en,ru \
  --scenarios 1,3
```

Both selection options are optional. Locale values are source language keys
from `integration_test/screenshots/screenshot_config.dart`. Each key can expand
to one or more configured output locales. Currently `en` writes `en-US`, while
`ru` writes `ru`; add output locale IDs to either list if another metadata
variant needs the same screenshots. Unknown, empty, or duplicate values fail
the run. Omitting an option selects every configured value.
`en-US` remains the complete baseline because F-Droid uses it as the fallback
language when localized metadata is unavailable.

Requires the FVM SDK, Android SDK Platform 37.0, NDK 28.2.13676358, and
`adb` on `PATH`.
On Windows, run the script from Git Bash or another POSIX-compatible shell.

The command builds a profile APK with `ENV=demo`, then passes that APK to
`flutter drive`. Using the APK makes Flutter read the actual demo application ID
instead of inferring the regular ID without the Dart environment. Every requested
source-locale/scenario pair is captured in one application launch and one
integration scenario, then written to every output locale mapped from that
source.

For each requested source locale, the scenario selects the dark theme and UI
language through Settings. The demo source follows only the UI language;
publication-language preferences are left untouched. My Feed and News are
refreshed through pull-to-refresh after each locale selection. Profile mode
avoids the DEBUG banner, Device Preview, and debug card information. No account
is required. The scenario also enables short descriptions through publication
settings and checks that the article excerpt and illustration are visible.

| File | Screen |
|------|--------|
| `1.png` | My Feed |
| `2.png` | News with compact filters |
| `3.png` | Publication reader |
| `4.png` | Settings → Interface |

Output:
`fastlane/metadata/android/<locale>/images/phoneScreenshots/<scenario>.png`.
The driver stages and validates the selected matrix. Only after the capture
succeeds does the script replace the corresponding PNG files; unselected
screenshots and other metadata remain untouched. The isolated
`ru.iska9der.flabr.demo.debug` installation is reset before capture if present
and removed by the driver afterward. Regular Flabr installations and their
settings or sessions are not cleared.

`ENV=demo` registers `DemoPublicationService` through the shared `@demo`
annotation from `lib/core/constants/environment.dart`. It supplies
locale-specific Dart models from `lib/data/demo/demo_publications.dart` and
bundled images from `assets/demo/`; the configured screenshot surfaces work
offline. Cards use short leads, while the reader uses longer excerpts sized for
the opening screenshot viewport. The reader stays at the start instead of
scrolling to an offscreen illustration. No full article body or API response is
stored. Demo articles retain their source authors and metadata while sharing
`assets/demo/avatar.png`. One authored news snippet per locale remains for the
News filter background.

Normal repositories, BLoCs, and screens remain in use. This is a publication
demo source, not an offline replacement for unrelated services; voting and
bookmark mutations are unavailable. There is no API fixture server or response
JSON. Screen order and locales are defined in
`integration_test/screenshots/screenshot_config.dart`.

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
.fvm/flutter_sdk/bin/flutter pub run build_runner build
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
# Test the pure Dart ya_summary package
.fvm/flutter_sdk/bin/dart test packages/ya_summary

# Analyze the pure Dart ya_summary package
.fvm/flutter_sdk/bin/dart analyze packages/ya_summary

# Test a Flutter package
.fvm/flutter_sdk/bin/flutter test packages/quick_shortcuts

# Analyze a Flutter package
.fvm/flutter_sdk/bin/flutter analyze packages/flutter_highlight
```

## Common Workflows

### Starting Development

```bash
# 1. Get dependencies
.fvm/flutter_sdk/bin/flutter pub get

# 2. Generate code in watch mode
.fvm/flutter_sdk/bin/flutter pub run build_runner watch

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
.fvm/flutter_sdk/bin/flutter pub run build_runner build
```

### Release Build

```bash
# 1. Update version
sh scripts/version.sh --up

# 2. Generate code
.fvm/flutter_sdk/bin/flutter pub run build_runner build

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
.fvm/flutter_sdk/bin/flutter pub run build_runner build
```

**Issue:** "Conflicts" during build_runner
```bash
# Solution: Clean the generator cache and rebuild
.fvm/flutter_sdk/bin/flutter pub run build_runner clean
.fvm/flutter_sdk/bin/flutter pub run build_runner build
```

## Related Documentation

- [Code Style](code-style.md) - Code style guidelines
- [Common Tasks](common-tasks.md) - Common development tasks
- [Architecture Overview](../architecture/overview.md) - Project architecture

---

← [Back to CLAUDE.md](../../CLAUDE.md)
