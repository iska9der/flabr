import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../bloc/settings/settings_cubit.dart';
import '../../../core/component/router/router.dart';
import '../../../core/constants/constants.dart';
import '../../../di/di.dart';
import '../../../i18n/i18n.dart' as app_localizations;
import '../../extension/extension.dart';
import '../../page/settings/model/config_model.dart';
import '../../theme/theme.dart';
import '../config/config.dart';

/// Основной view приложения с конфигурацией MaterialApp.
///
/// Отвечает за:
/// - Настройку темы и локализации
/// - Конфигурацию роутера
/// - Настройку responsive дизайна
class ApplicationView extends StatelessWidget {
  const ApplicationView({super.key});

  @override
  Widget build(BuildContext context) {
    final config = AppConfigProvider.of(context);
    final locale = app_localizations.TranslationProvider.of(
      context,
    ).flutterLocale;

    final themeConfig = context.select<SettingsCubit, ThemeConfigModel>(
      (cubit) => cubit.state.theme,
    );
    final themeMode = themeConfig.modeByBool ?? themeConfig.mode;

    final scrollBehavior = context
        .select((SettingsCubit cubit) => cubit.state.misc.scrollVariant)
        .behavior;
    final textScaleFactor = context.select<SettingsCubit, double>(
      (cubit) => cubit.state.typography.textScaleFactor,
    );
    final typographyConfig = context
        .select<SettingsCubit, TypographyConfigModel>(
          (cubit) => cubit.state.typography,
        );
    final router = getIt<AppRouter>();

    return MaterialApp.router(
      title: AppEnvironment.appName,
      locale: locale,
      supportedLocales: app_localizations.AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      themeMode: themeMode,
      theme: AppTheme.light(typographyConfig: typographyConfig),
      darkTheme: themeConfig.isAmoledTheme
          ? AppTheme.amoled(typographyConfig: typographyConfig)
          : AppTheme.dark(typographyConfig: typographyConfig),
      scrollBehavior: scrollBehavior,
      routerConfig: router.config(
        deepLinkTransformer: (uri) {
          return SynchronousFuture(router.transformDeepLink(uri));
        },
      ),
      builder: (context, child) => _buildAppWrapper(
        context,
        config,
        textScaleFactor,
        child,
      ),
    );
  }

  Widget _buildAppWrapper(
    BuildContext context,
    AppConfig config,
    double textScaleFactor,
    Widget? child,
  ) {
    final theme = context.theme;
    final brightness = theme.colorScheme.brightness;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: .linear(textScaleFactor),
      ),
      child: ResponsiveBreakpoints.builder(
        breakpoints: config.responsiveBreakpoints,
        child: ColoredBox(
          color: theme.colors.background,
          child: MaxWidthBox(
            maxWidth: config.maxWidth,
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: switch (brightness) {
                .light => .dark,
                .dark => .light,
              },
              child: SkeletonizerConfig(
                data: .new(brightness: brightness),
                child: child ?? const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
