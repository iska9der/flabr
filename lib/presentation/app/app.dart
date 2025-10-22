import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'bootstrap/app_bootstrap.dart';
import 'config/app_config.dart';
import 'config/app_config_provider.dart';
import 'coordinator/global_bloc_listener.dart';
import 'provider/global_bloc_provider.dart';
import 'view/application_view.dart';
import 'view/splash_screen.dart';

export 'config/app_config.dart';
export 'view/application_view.dart';

/// Точка входа в приложение.
///
/// Выстраивает иерархию виджетов в следующем порядке:
/// [DevicePreview] - инструмент для тестирования на разных устройствах (только dev)
/// [AppConfigProvider] - предоставляет конфигурацию приложения
/// [GlobalBlocProvider] - создает глобальные BLoC провайдеры
/// [GlobalBlocListener] - глобальные BLoC listeners для координации
/// [AppBootstrap] - управляет инициализацией и splash screen
/// [ApplicationView] - основной MaterialApp виджет
class Application extends StatelessWidget {
  const Application({
    super.key,
    this.config,
  });

  /// Конфигурация приложения.
  /// По умолчанию использует production конфигурацию.
  /// Для разработки передайте [AppConfig.dev].
  final AppConfig? config;

  @override
  Widget build(BuildContext context) {
    final appConfig = config ?? (kDebugMode ? AppConfig.dev : AppConfig.prod);

    final app = AppConfigProvider(
      config: appConfig,
      child: GlobalBlocProvider(
        child: GlobalBlocListener(
          child: AppBootstrap(
            minimumDuration: appConfig.splashMinDuration,
            splash: const SplashScreen(),
            child: const ApplicationView(),
          ),
        ),
      ),
    );

    // Оборачиваем в DevicePreview только для dev окружения
    if (appConfig.enableDevicePreview) {
      return DevicePreview(builder: (_) => app);
    }

    return app;
  }
}
