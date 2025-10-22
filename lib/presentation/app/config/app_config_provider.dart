import 'package:flutter/widgets.dart';

import 'app_config.dart';

/// InheritedWidget для предоставления [AppConfig] вниз по дереву виджетов.
class AppConfigProvider extends InheritedWidget {
  const AppConfigProvider({
    required this.config,
    required super.child,
    super.key,
  });

  final AppConfig config;

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

  @override
  bool updateShouldNotify(AppConfigProvider oldWidget) {
    return config != oldWidget.config;
  }
}
