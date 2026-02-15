import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../bloc/settings/settings_cubit.dart';
import '../../../core/component/router/router.dart';
import '../../../core/constants/constants.dart';
import '../../../di/di.dart';
import '../../extension/extension.dart';
import '../../theme/theme.dart';
import '../config/app_config.dart';
import '../config/app_config_provider.dart';

/// Основной view приложения с конфигурацией MaterialApp.
///
/// Отвечает за:
/// - Настройку темы и локализации
/// - Конфигурацию роутера
/// - Настройку responsive дизайна
/// - Интеграцию с DevicePreview (только для dev окружения)
class ApplicationView extends StatelessWidget {
  const ApplicationView({super.key});

  @override
  Widget build(BuildContext context) {
    final config = AppConfigProvider.of(context);
    final locale = switch (config.enableDevicePreview) {
      true => DevicePreview.locale(context),
      false => null,
    };

    final themeMode = context.select<SettingsCubit, ThemeMode>(
      (cubit) => cubit.state.theme.modeByBool ?? cubit.state.theme.mode,
    );

    final scrollBehavior = context
        .select((SettingsCubit cubit) => cubit.state.misc.scrollVariant)
        .behavior;

    return MaterialApp.router(
      title: AppEnvironment.appName,
      // ignore: deprecated_member_use
      useInheritedMediaQuery: true,
      locale: locale,
      themeMode: themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      scrollBehavior: scrollBehavior,
      routerConfig: getIt<AppRouter>().config(
        deepLinkTransformer: (uri) {
          if (uri.path.startsWith('/ru')) {
            final newPath = uri.path.replaceFirst('/ru', '');
            return SynchronousFuture(uri.replace(path: newPath));
          }
          return SynchronousFuture(uri);
        },
      ),
      builder: (context, child) => _buildAppWrapper(
        context,
        config,
        child,
      ),
    );
  }

  Widget _buildAppWrapper(
    BuildContext context,
    AppConfig config,
    Widget? child,
  ) {
    final theme = context.theme;

    Widget result = ColoredBox(
      color: theme.colors.surface,
      child: MaxWidthBox(
        maxWidth: config.maxWidth,
        child: AnnotatedRegion(
          value: switch (theme.colorScheme.brightness) {
            Brightness.light => SystemUiOverlayStyle.light,
            Brightness.dark => SystemUiOverlayStyle.dark,
          },
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );

    result = ResponsiveBreakpoints.builder(
      child: result,
      breakpoints: config.responsiveBreakpoints,
    );

    if (config.enableDevicePreview) {
      result = DevicePreview.appBuilder(context, result);
    }

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: .linear(config.textScaleFactor),
      ),
      child: result,
    );
  }
}
