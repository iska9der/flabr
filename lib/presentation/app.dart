import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ya_summary/ya_summary.dart';

import '../core/component/router/app_router.dart';
import '../di/di.dart';
import '../feature/auth/auth.dart';
import 'extension/extension.dart';
import 'page/settings/cubit/settings_cubit.dart';
import 'theme/theme.dart';
import 'widget/enhancement/progress_indicator.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create:
              (_) => SettingsCubit(
                languageRepository: getIt(),
                storage: getIt(instanceName: 'sharedStorage'),
              )..init(),
        ),
        BlocProvider(
          lazy: false,
          create:
              (_) =>
                  AuthCubit(repository: getIt(), tokenRepository: getIt())
                    ..init(),
        ),
        BlocProvider(
          lazy: false,
          create: (_) => SummaryAuthCubit(tokenRepository: getIt())..init(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthState>(
            listenWhen:
                (previous, current) =>
                    previous.status.isLoading && current.isAuthorized,
            listener: (context, _) {
              context.read<AuthCubit>().fetchMe();
              context.read<AuthCubit>().fetchUpdates();
            },
          ),
        ],
        child: ApplicationView(),
      ),
    );
  }
}

class ApplicationView extends StatelessWidget {
  const ApplicationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SettingsCubit, SettingsState, SettingsStatus>(
      selector: (state) => state.status,
      builder: (context, status) {
        if (status == SettingsStatus.loading) {
          /// TODO: Splash Page
          return const Material(child: CircleIndicator());
        }

        final themeConfig = context.select(
          (SettingsCubit cubit) => cubit.state.theme,
        );

        final scroll = context.select(
          (SettingsCubit cubit) => cubit.state.misc.scrollVariant,
        );

        return MaterialApp.router(
          title: 'Flabr',
          // ignore: deprecated_member_use
          useInheritedMediaQuery: true,
          locale: DevicePreview.locale(context),
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
          builder: (context, child) {
            final theme = context.theme;

            return DevicePreview.appBuilder(
              context,
              ResponsiveBreakpoints.builder(
                child: ColoredBox(
                  color: theme.colors.surface,
                  child: MaxWidthBox(
                    maxWidth: AppDimensions.maxWidth,
                    child: AnnotatedRegion(
                      value:
                          theme.colorScheme.brightness == Brightness.dark
                              ? SystemUiOverlayStyle.light
                              : SystemUiOverlayStyle.dark,
                      child: child ?? const SizedBox.shrink(),
                    ),
                  ),
                ),
                breakpoints: [
                  const Breakpoint(start: 0, end: 600, name: ScreenType.mobile),
                  const Breakpoint(
                    start: 601,
                    end: 840,
                    name: ScreenType.tablet,
                  ),
                  const Breakpoint(
                    start: 841,
                    end: double.infinity,
                    name: ScreenType.desktop,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
