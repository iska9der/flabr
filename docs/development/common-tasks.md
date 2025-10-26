# Common Development Tasks

← [Back to CLAUDE.md](../../CLAUDE.md)

This guide covers common development tasks and workflows.

## Adding a New Feature

### 1. Plan Feature Structure

Determine if it's a **self-contained feature** or **app-wide functionality**.

**Self-contained feature** (goes in `lib/feature/`):
- Has its own Cubit + widgets + models
- Isolated functionality
- Example: image viewer, download manager

**App-wide functionality** (goes in `lib/bloc/` + `lib/presentation/`):
- Shared across multiple screens
- Integrated with navigation
- Example: publications, search, user profiles

### 2. Create Feature Module

#### For Self-Contained Feature

```bash
# Create feature directory
mkdir -p lib/feature/my_feature
mkdir -p lib/feature/my_feature/cubit
mkdir -p lib/feature/my_feature/widget
```

**Structure:**
```
lib/feature/my_feature/
├── cubit/
│   ├── my_feature_cubit.dart
│   └── my_feature_state.dart
├── widget/
│   ├── my_feature_widget.dart
│   └── my_feature_item.dart
└── my_feature.dart  # Public API
```

#### For App-Wide Feature

```bash
# Create BLoC
mkdir -p lib/bloc/my_feature

# Create models
mkdir -p lib/data/model/my_feature

# Create pages
mkdir -p lib/presentation/page/my_feature

# Create widgets
mkdir -p lib/presentation/widget/my_feature
```

### 3. Create Data Models

```dart
// lib/data/model/my_feature/my_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_model.freezed.dart';
part 'my_model.g.dart';

@freezed
class MyModel with _$MyModel {
  const factory MyModel({
    required String id,
    required String name,
    String? description,
  }) = _MyModel;

  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);
}
```

### 4. Create BLoC/Cubit

```dart
// lib/bloc/my_feature/my_feature_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../data/model/loading_status_enum.dart';
import '../../data/repository/my_feature_repository.dart';

part 'my_feature_state.dart';
part 'my_feature_cubit.freezed.dart';

@injectable
class MyFeatureCubit extends Cubit<MyFeatureState> {
  MyFeatureCubit(this._repository) : super(const MyFeatureState());

  final MyFeatureRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(status: LoadingStatus.loading));

    try {
      final data = await _repository.fetchData();
      emit(state.copyWith(
        status: LoadingStatus.success,
        data: data,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LoadingStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
```

```dart
// lib/bloc/my_feature/my_feature_state.dart
part of 'my_feature_cubit.dart';

@freezed
class MyFeatureState with _$MyFeatureState {
  const factory MyFeatureState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default([]) List<MyModel> data,
    String? error,
  }) = _MyFeatureState;
}
```

### 5. Create Repository

```dart
// lib/data/repository/my_feature_repository.dart
import 'package:injectable/injectable.dart';

import '../model/my_feature/my_model.dart';
import '../service/my_feature_service.dart';

@injectable
class MyFeatureRepository {
  final MyFeatureService _service;

  MyFeatureRepository(this._service);

  Future<List<MyModel>> fetchData() async {
    final response = await _service.getData();
    return response.map((json) => MyModel.fromJson(json)).toList();
  }
}
```

### 6. Register in DI

Dependencies are automatically registered via `@injectable` annotation.

```bash
# Run code generation to register
.fvm/flutter_sdk/bin/flutter pub run build_runner build --delete-conflicting-outputs
```

### 7. Add Pages/Widgets

```dart
// lib/presentation/page/my_feature/my_feature_page.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/my_feature/my_feature_cubit.dart';
import '../../../core/di/injector.dart';

@RoutePage()
class MyFeaturePage extends StatelessWidget {
  const MyFeaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MyFeatureCubit>()..load(),
      child: const MyFeatureView(),
    );
  }
}

class MyFeatureView extends StatelessWidget {
  const MyFeatureView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Feature')),
      body: BlocBuilder<MyFeatureCubit, MyFeatureState>(
        builder: (context, state) {
          if (state.status == LoadingStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == LoadingStatus.failure) {
            return Center(child: Text('Error: ${state.error}'));
          }

          return ListView.builder(
            itemCount: state.data.length,
            itemBuilder: (context, index) {
              final item = state.data[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text(item.description ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}
```

### 8. Register Routes (if needed)

```dart
// lib/core/component/router/app_router.dart
@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    // ... existing routes
    AutoRoute(page: MyFeatureRoute.page, path: '/my-feature'),
  ];
}
```

### 9. Generate Code

```bash
# Generate all code (models, DI, routes)
.fvm/flutter_sdk/bin/flutter pub run build_runner build --delete-conflicting-outputs
```

### 10. Test Feature

```bash
# Run app
.fvm/flutter_sdk/bin/flutter run

# Navigate to /my-feature
# Or use context.router.push(MyFeatureRoute())
```

## Adding a New API Endpoint

### 1. Define Data Model

```dart
// lib/data/model/my_feature/my_response.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_response.freezed.dart';
part 'my_response.g.dart';

@freezed
class MyResponse with _$MyResponse {
  const factory MyResponse({
    required String id,
    required String data,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _MyResponse;

  factory MyResponse.fromJson(Map<String, dynamic> json) =>
      _$MyResponseFromJson(json);
}
```

### 2. Add Service Method

```dart
// lib/data/service/my_feature_service.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../model/my_feature/my_response.dart';

part 'my_feature_service.g.dart';

@injectable
@RestApi()
abstract class MyFeatureService {
  @factoryMethod
  factory MyFeatureService(Dio dio) = _MyFeatureService;

  @GET('/api/my-endpoint')
  Future<List<MyResponse>> getData();

  @GET('/api/my-endpoint/{id}')
  Future<MyResponse> getById(@Path('id') String id);

  @POST('/api/my-endpoint')
  Future<MyResponse> create(@Body() Map<String, dynamic> data);

  @PUT('/api/my-endpoint/{id}')
  Future<MyResponse> update(
    @Path('id') String id,
    @Body() Map<String, dynamic> data,
  );

  @DELETE('/api/my-endpoint/{id}')
  Future<void> delete(@Path('id') String id);
}
```

### 3. Update Repository

```dart
// lib/data/repository/my_feature_repository.dart
@injectable
class MyFeatureRepository {
  final MyFeatureService _service;

  MyFeatureRepository(this._service);

  Future<List<MyResponse>> fetchAll() async {
    return await _service.getData();
  }

  Future<MyResponse> fetchById(String id) async {
    return await _service.getById(id);
  }

  Future<MyResponse> create(Map<String, dynamic> data) async {
    return await _service.create(data);
  }

  Future<MyResponse> update(String id, Map<String, dynamic> data) async {
    return await _service.update(id, data);
  }

  Future<void> delete(String id) async {
    await _service.delete(id);
  }
}
```

### 4. Generate Code

```bash
.fvm/flutter_sdk/bin/flutter pub run build_runner build --delete-conflicting-outputs
```

### 5. Use in BLoC

```dart
// lib/bloc/my_feature/my_feature_cubit.dart
@injectable
class MyFeatureCubit extends Cubit<MyFeatureState> {
  MyFeatureCubit(this._repository) : super(const MyFeatureState());

  final MyFeatureRepository _repository;

  Future<void> create(Map<String, dynamic> data) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    try {
      final result = await _repository.create(data);
      emit(state.copyWith(
        status: LoadingStatus.success,
        data: [...state.data, result],
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LoadingStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
```

## Modifying State Management

### 1. Update State Class

```dart
// lib/bloc/my_feature/my_feature_state.dart
@freezed
class MyFeatureState with _$MyFeatureState {
  const factory MyFeatureState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default([]) List<MyModel> data,
    @Default(false) bool hasMore, // New field
    String? error,
  }) = _MyFeatureState;
}
```

### 2. Regenerate Code

```bash
.fvm/flutter_sdk/bin/flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Update BLoC Methods

```dart
// lib/bloc/my_feature/my_feature_cubit.dart
Future<void> loadMore() async {
  if (!state.hasMore || state.status == LoadingStatus.loading) return;

  emit(state.copyWith(status: LoadingStatus.loading));

  try {
    final newData = await _repository.fetchMore(state.data.length);
    emit(state.copyWith(
      status: LoadingStatus.success,
      data: [...state.data, ...newData],
      hasMore: newData.isNotEmpty,
    ));
  } catch (e) {
    emit(state.copyWith(
      status: LoadingStatus.failure,
      error: e.toString(),
    ));
  }
}
```

### 4. Update UI

```dart
// lib/presentation/page/my_feature/my_feature_page.dart
BlocBuilder<MyFeatureCubit, MyFeatureState>(
  builder: (context, state) {
    return ListView.builder(
      itemCount: state.data.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.data.length) {
          // Load more indicator
          context.read<MyFeatureCubit>().loadMore();
          return const Center(child: CircularProgressIndicator());
        }

        final item = state.data[index];
        return ListTile(title: Text(item.name));
      },
    );
  },
)
```

## Adding Global BLoC

### 1. Create BLoC

Follow steps from "Adding a New Feature" section.

### 2. Register in GlobalBlocProvider

```dart
// lib/presentation/app/provider/global_bloc_provider.dart
class GlobalBlocProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Existing BLoCs...
        BlocProvider(
          create: (context) => getIt<MyFeatureCubit>()..initialize(),
          lazy: false, // or true if on-demand
        ),
      ],
      child: child,
    );
  }
}
```

### 3. Add Coordination (if needed)

```dart
// lib/presentation/app/coordinator/global_bloc_listener.dart
class GlobalBlocListener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Existing listeners...
        BlocListener<MyFeatureCubit, MyFeatureState>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            // React to state changes
          },
        ),
      ],
      child: child,
    );
  }
}
```

## Debugging Tips

### Enable Detailed Logging

```dart
// In BLoC/Cubit
@override
void emit(MyFeatureState state) {
  logger.info('State: $state', title: 'MyFeatureCubit');
  super.emit(state);
}
```

### Use BlocObserver

```dart
// lib/core/bloc_observer.dart
class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    logger.info('$change', title: bloc.runtimeType.toString());
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    logger.error('BLoC error', error, stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}

// In main.dart
void main() {
  Bloc.observer = AppBlocObserver();
  runApp(Application());
}
```

## Related Documentation

- [Commands](commands.md) - Development commands
- [Code Style](code-style.md) - Code style guidelines
- [Architecture Overview](../architecture/overview.md) - Project architecture

---

← [Back to CLAUDE.md](../../CLAUDE.md)
