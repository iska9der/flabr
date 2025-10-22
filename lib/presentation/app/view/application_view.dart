import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../bloc/settings/settings_cubit.dart';
import '../../../core/component/router/app_router.dart';
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
    final themeConfig = context.select(
      (SettingsCubit cubit) => cubit.state.theme,
    );

    final scroll = context.select(
      (SettingsCubit cubit) => cubit.state.misc.scrollVariant,
    );

    final appConfig = AppConfigProvider.of(context);

    return MaterialApp.router(
      title: AppEnvironment.appName,
      // ignore: deprecated_member_use
      useInheritedMediaQuery: true,
      locale: appConfig.enableDevicePreview
          ? DevicePreview.locale(context)
          : null,
      themeMode: themeConfig.modeByBool ?? themeConfig.mode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      scrollBehavior: scroll.behavior,
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
        child,
        appConfig,
      ),
    );
  }

  Widget _buildAppWrapper(
    BuildContext context,
    Widget? child,
    AppConfig appConfig,
  ) {
    final theme = context.theme;

    Widget result = ColoredBox(
      color: theme.colors.surface,
      child: MaxWidthBox(
        maxWidth: appConfig.maxWidth,
        child: AnnotatedRegion(
          value: theme.colorScheme.brightness == Brightness.dark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );

    result = ResponsiveBreakpoints.builder(
      child: result,
      breakpoints: appConfig.responsiveBreakpoints,
    );

    if (appConfig.enableDevicePreview) {
      result = DevicePreview.appBuilder(context, result);
    }

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(appConfig.textScaleFactor),
      ),
      child: result,
    );
  }
}
