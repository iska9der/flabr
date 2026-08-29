import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:ya_summary/i18n/i18n.dart' as ya_summary_localizations;

import '../../di/di.dart';
import '../../i18n/i18n.dart' as app_localizations;
import 'config/config.dart';
import 'coordinator/global_bloc_listener.dart';
import 'provider/global_bloc_provider.dart';
import 'view/application_view.dart';

export 'config/config.dart';
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
  const Application({super.key, this.config = .prod});

  /// Конфигурация приложения.
  /// По умолчанию использует production конфигурацию.
  /// Для разработки передайте [AppConfig.dev].
  final AppConfig config;

  @override
  Widget build(BuildContext context) {
    final app = app_localizations.TranslationProvider(
      child: ya_summary_localizations.TranslationProvider(
        child: AppConfigProvider(
          config: config,
          repository: getIt<AppConfigRepository>(),
          child: const GlobalBlocProvider(
            child: GlobalBlocListener(
              child: HighlightBackgroundEnvironment(
                child: ApplicationView(),
              ),
            ),
          ),
        ),
      ),
    );

    // Оборачиваем в DevicePreview только для dev окружения
    if (config.enableDevicePreview) {
      return DevicePreview(builder: (_) => app);
    }

    return app;
  }
}
