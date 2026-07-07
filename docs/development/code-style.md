# Code Style Guidelines

← [Back to CLAUDE.md](../../CLAUDE.md)

## Linting Rules

Project follows rules defined in `analysis_options.yaml`.

### String Formatting

```dart
// ✅ Good: Use single quotes
final String name = 'John';
final String greeting = 'Hello, $name';  // Interpolation works with single quotes

// ❌ Bad: Double quotes (unless necessary)
final String name = "John";

// ✅ Good: Double quotes when string contains single quote
final String text = "It's a string";

// ✅ Good: Or escape single quote
final String text = 'It\'s a string';
```

### Imports

```dart
// ✅ Good: Prefer relative imports within lib/
import '../bloc/auth/auth_cubit.dart';
import '../data/model/user.dart';

// ❌ Bad: Absolute imports within lib/
import 'package:flabr/bloc/auth/auth_cubit.dart';

// ✅ Good: Absolute imports for packages
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
```

### Const Constructors

```dart
// ✅ Good: Use const when possible
const SizedBox(height: 16);
const EdgeInsets.all(8);

// ❌ Bad: Missing const
SizedBox(height: 16);
EdgeInsets.all(8);
```

### Return Types

```dart
// ✅ Good: Always declare return types
String getUserName() {
  return 'John';
}

Future<void> fetchData() async {
  // ...
}

// ❌ Bad: Implicit return type
getUserName() {  // Missing return type
  return 'John';
}
```

### Super Parameters

```dart
// ✅ Good: Use super parameters (Dart 2.17+)
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// ❌ Bad: Old-style parameter passing
class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);
}
```

### Trailing Commas

```dart
// ✅ Good: Use trailing commas for better formatting
Container(
  padding: const EdgeInsets.all(8),
  child: Text('Hello'),
); // ← Trailing comma

// Enables better auto-formatting
final list = [
  'item1',
  'item2',
  'item3', // ← Trailing comma
];
```

## Documentation Comments

### Comment Style

**IMPORTANT**: Use triple-slash `///` for documentation comments (Dart convention).

```dart
/// Fetches user profile from the server.
///
/// Returns [UserProfile] if successful, throws [ApiException] otherwise.
Future<UserProfile> fetchProfile() async {
  // ...
}

// ✅ Good: /// for documentation
/// This is a public class
class MyClass {}

// ❌ Bad: // for public API documentation
// This is a public class
class MyClass {}

// ✅ Good: // for implementation comments
void _privateMethod() {
  // This is an implementation detail
  final result = calculate();
}
```

### Language Guidelines

Write comments in Russian, but keep technical terms and service names in their original language.

```dart
/// Выполняет аутентификацию через OAuth провайдер.
///
/// Поддерживаемые провайдеры: GitHub, Google, VK, Yandex.
///
/// Throws [AuthException] если аутентификация не удалась.
Future<void> authenticateWithOAuth(OAuthProvider provider) async {
  // ...
}

/// Инициализирует WebView для логина.
///
/// URL: ${Urls.siteApiUrl}/v1/auth/habrahabr/?back=/ru/all
void initializeLoginWebView() {
  // ...
}
```

**Technical Terms (Keep in English):**
- OAuth, GitHub, Google, VK, Yandex
- WebView, API, URL, HTTP
- BLoC, Cubit, State
- Flutter, Dart
- JSON, DTO, Repository

**Descriptions (Write in Russian):**
- Function/method descriptions
- Parameter descriptions
- Class/widget purposes
- Implementation notes

## BLoC/Cubit Conventions

### State Management

```dart
// ✅ Good: Use freezed for immutability
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    required AuthStatus status,
    required LoadingStatus loadingStatus,
    String? error,
  }) = _AuthState;
}

// ✅ Good: Use freezed unions for events
@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.login(String token) = _Login;
  const factory AuthEvent.logout() = _Logout;
  const factory AuthEvent.checkAuth() = _CheckAuth;
}
```

### LoadingStatus Enum

**CRITICAL**: Always use the shared `LoadingStatus` enum from `lib/data/model/loading_status_enum.dart`.

```dart
// ✅ Good: Use shared LoadingStatus enum
import 'package:flabr/data/model/loading_status_enum.dart';

@freezed
class MyState with _$MyState {
  const factory MyState({
    required LoadingStatus status,
  }) = _MyState;
}

// ❌ Bad: Creating custom status enum
enum MyCustomStatus { initial, loading, success, failure }
```

**LoadingStatus Values:**
- `initial` - Initial state, no operation started
- `loading` - Operation in progress
- `success` - Operation completed successfully
- `failure` - Operation failed

### Async Operations in UI

**CRITICAL**: Never use `await` when calling Cubit/Bloc methods from UI.

```dart
// ✅ Good: Fire-and-forget, react via BlocListener
ElevatedButton(
  onPressed: () {
    context.read<AuthCubit>().login(token); // No await!
  },
  child: Text('Login'),
)

BlocListener<AuthCubit, AuthState>(
  listener: (context, state) {
    if (state.status == LoadingStatus.success) {
      Navigator.pop(context);
    }
  },
  child: MyWidget(),
)

// ❌ Bad: Using await
ElevatedButton(
  onPressed: () async {
    await context.read<AuthCubit>().login(token); // ❌ Race condition risk!
    Navigator.pop(context); // May execute after Cubit is closed
  },
  child: Text('Login'),
)
```

**Why No Await?**
- Prevents race conditions
- Cubit might be closed before awaited method completes
- UI should react to state changes, not await completion

### UI State Reactions

```dart
// ✅ Good: Use BlocListener for side effects
BlocListener<AuthCubit, AuthState>(
  listener: (context, state) {
    if (state.status == LoadingStatus.failure) {
      showErrorSnackbar(context, state.error);
    }
  },
  child: MyWidget(),
)

// ✅ Good: Use BlocBuilder for UI updates
BlocBuilder<AuthCubit, AuthState>(
  builder: (context, state) {
    if (state.status == LoadingStatus.loading) {
      return CircularProgressIndicator();
    }
    return MyContent();
  },
)

// ✅ Good: Use BlocConsumer for both
BlocConsumer<AuthCubit, AuthState>(
  listener: (context, state) {
    // Side effects
  },
  builder: (context, state) {
    // UI updates
  },
)
```

### BLoC Architecture Principles

```dart
// ✅ Good: Business logic in BLoC
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.repository) : super(const AuthState());

  final AuthRepository repository;

  Future<void> login(String token) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    try {
      await repository.saveToken(token);
      emit(state.copyWith(status: LoadingStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: LoadingStatus.failure,
        error: e.toString(),
      ));
    }
  }
}

// ❌ Bad: Business logic in UI
class LoginPage extends StatelessWidget {
  Future<void> login() async {
    // ❌ Business logic should be in BLoC
    final token = await api.login(email, password);
    await storage.save(token);
  }
}

// ✅ Good: Use repositories, not services directly
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.repository) : super(const AuthState());

  final AuthRepository repository; // ✅ Repository abstraction

  Future<void> login() async {
    await repository.login(); // Repository handles service calls
  }
}

// ❌ Bad: Direct service access
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.service) : super(const AuthState());

  final AuthService service; // ❌ Direct service dependency

  Future<void> login() async {
    await service.login();
  }
}
```

## Code Generation

### When to Run build_runner

After modifying:
- Models with `@freezed` annotation
- Models with `@JsonSerializable` annotation
- DI annotations (`@injectable`, `@singleton`, `@lazySingleton`)
- Routes with `@RoutePage` annotation
- DI modules

```bash
# Generate code
.fvm/flutter_sdk/bin/flutter pub run build_runner build --delete-conflicting-outputs
```

### Generated Files

**DO NOT EDIT** these files manually:
- `*.g.dart` - JSON serialization
- `*.freezed.dart` - Freezed models
- `*.gr.dart` - Auto route
- `*.config.dart` - Injectable DI

### Excluding Generated Files

Generated files are excluded from analysis in `analysis_options.yaml`:

```yaml
analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.gr.dart"
    - "**/*.freezed.dart"
    - "**/*.config.dart"
```

## File Organization

### Class Member Ordering

**Flutter Convention**: Follow the same ordering as Flutter framework widgets.

**Order:**
1. **Constructor** (often const)
2. **Fields** (final properties)
3. **Methods** (build, overrides, public methods, private methods)

```dart
// ✅ Good: Flutter-style ordering
class MyWidget extends StatelessWidget {
  const MyWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}

// ✅ Good: Same for BLoC/Cubit
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.repository) : super(const AuthState());

  final AuthRepository repository;

  Future<void> login() async {
    // ...
  }
}

// ❌ Bad: Fields before constructor
class MyWidget extends StatelessWidget {
  final String title;  // ❌ Wrong order

  const MyWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}
```

**Why this order?**
- Consistent with Flutter framework source code
- Constructor is the entry point - should be seen first
- Fields are declared by constructor parameters
- Methods use the fields

### Constants Scope

Keep constants in the smallest scope that owns their usage.

```dart
// ✅ Good: Used only by this State, so keep it inside the owner
class _FontScaleCardState extends State<FontScaleCard> {
  static const double _minFontSize = 12;

  // ...
}

// ❌ Bad: Do not move it to file scope until another owner needs it
const double _minFontSize = 12;
```

Move constants to file scope only when they are shared by multiple classes,
widgets, or top-level helpers in the same file. Move them to shared constants
only when they are reused across files.

### Naming Conventions

```dart
// Files: snake_case
auth_cubit.dart
user_repository.dart
publication_detail_page.dart

// Classes: PascalCase
class AuthCubit extends Cubit<AuthState> {}
class UserRepository {}
class PublicationDetailPage extends StatelessWidget {}

// Variables/methods: camelCase
final userName = 'John';
void fetchUserData() {}

// Constants: lowerCamelCase or UPPER_CASE
const maxRetries = 3;
const API_TIMEOUT = Duration(seconds: 30);

// Private: prefix with _
class _PrivateClass {}
void _privateMethod() {}
final _privateField = 'value';
```

### Import Ordering

```dart
// 1. Dart imports
import 'dart:async';
import 'dart:io';

// 2. Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Package imports (alphabetically)
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// 4. Relative imports (alphabetically)
import '../bloc/auth/auth_cubit.dart';
import '../data/model/user.dart';

// 5. Part/generated files
part 'auth_state.freezed.dart';
part 'auth_state.g.dart';
```

## Formatting

### Line Length

Maximum line length: **80 characters** (recommended) or **120 characters** (acceptable).

```dart
// ✅ Good: Break long lines
final longString = 'This is a very long string that '
    'should be broken into multiple lines '
    'for better readability';

// ✅ Good: Break method chains
repository
    .fetchData()
    .then((data) => processData(data))
    .catchError((e) => handleError(e));
```

### Auto-Formatting

```bash
# Format all files
.fvm/flutter_sdk/bin/dart format .

# Format preserves trailing commas
.fvm/flutter_sdk/bin/dart format lib/
```

## Best Practices Summary

### DO

- ✅ Use single quotes for strings
- ✅ Use relative imports within `lib/`
- ✅ Use `const` constructors
- ✅ Declare return types
- ✅ Use super parameters
- ✅ Use trailing commas
- ✅ Use `///` for documentation
- ✅ Use shared `LoadingStatus` enum
- ✅ Call BLoC methods without `await` from UI
- ✅ Use `BlocListener`/`BlocBuilder` for state reactions
- ✅ Use repositories in BLoCs
- ✅ Run `build_runner` after model changes

### DON'T

- ❌ Use double quotes (unless necessary)
- ❌ Use absolute imports within `lib/`
- ❌ Omit return types
- ❌ Create custom status enums
- ❌ Use `await` on BLoC methods in UI
- ❌ Put business logic in UI
- ❌ Access services directly from BLoCs
- ❌ Edit generated files manually

## Related Documentation

- [Commands](commands.md) - Development commands including formatting/linting
- [Common Tasks](common-tasks.md) - Development workflows
- [Architecture Overview](../architecture/overview.md) - Project architecture

---

← [Back to CLAUDE.md](../../CLAUDE.md)
