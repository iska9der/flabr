import 'package:flutter/widgets.dart';

import 'app_config.dart';
import 'app_config_repository.dart';

/// InheritedWidget для предоставления [AppConfig] вниз по дереву виджетов.
class AppConfigProvider extends InheritedWidget {
  const AppConfigProvider({
    super.key,
    required this.config,
    required this.repository,
    required super.child,
  });

  final AppConfig config;
  final AppConfigRepository repository;

  /// Получить конфигурацию из контекста
  static AppConfig of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<AppConfigProvider>();
    assert(
      provider != null,
      'AppConfigProvider not found in widget tree. '
      'Make sure to wrap your app with AppConfigProvider.',
    );
    return provider!.config;
  }

  /// Получить репозиторий из контекста
  static AppConfigRepository repo(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<AppConfigProvider>();
    assert(
      provider != null,
      'AppConfigProvider not found in widget tree. '
      'Make sure to wrap your app with AppConfigProvider.',
    );
    return provider!.repository;
  }

  @override
  bool updateShouldNotify(AppConfigProvider oldWidget) {
    return config != oldWidget.config;
  }
}
