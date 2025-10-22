import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../theme/theme.dart';

part 'app_config.freezed.dart';

/// Конфигурация приложения.
///
/// Централизует все настройки уровня приложения.
@freezed
abstract class AppConfig with _$AppConfig {
  const factory AppConfig({
    /// Включить DevicePreview для тестирования на разных устройствах
    @Default(false) bool enableDevicePreview,

    /// Коэффициент масштабирования текста
    @Default(1.0) double textScaleFactor,

    /// Breakpoints для responsive дизайна
    @Default([
      Breakpoint(start: 0, end: 600, name: ScreenType.mobile),
      Breakpoint(start: 601, end: 840, name: ScreenType.tablet),
      Breakpoint(start: 841, end: double.infinity, name: ScreenType.desktop),
    ])
    List<Breakpoint> responsiveBreakpoints,

    /// Максимальная ширина контента приложения
    @Default(AppDimensions.maxWidth) double maxWidth,

    /// Минимальная длительность отображения splash screen.
    /// Если null, splash скрывается сразу после завершения инициализации.
    Duration? splashMinDuration,
  }) = _AppConfig;

  /// Конфигурация для разработки
  static const dev = AppConfig(enableDevicePreview: true);

  /// Конфигурация для production
  static const prod = AppConfig(
    splashMinDuration: Duration(seconds: 3),
  );
}
