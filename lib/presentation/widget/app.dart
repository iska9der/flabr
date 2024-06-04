import 'package:auto_route/auto_route.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../core/component/di/injector.dart';
import '../../core/component/router/app_router.dart';
import '../extension/part.dart';
import '../feature/auth/cubit/auth_cubit.dart';
import '../feature/summary/cubit/summary_auth_cubit.dart';
import '../page/settings/cubit/settings_cubit.dart';
import '../theme/part.dart';
import 'enhancement/progress_indicator.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppRouter router = getIt();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (_) => SettingsCubit(
            languageRepository: getIt(),
            storage: getIt(),
            router: router,
            appLinks: getIt(),
          )..init(),
        ),
        BlocProvider(
          lazy: false,
          create: (_) => AuthCubit(
            repository: getIt(),
            tokenRepository: getIt(),
          )..init(),
        ),
        BlocProvider(
          lazy: false,
          create: (_) => SummaryAuthCubit(
            tokenRepository: getIt(),
          )..init(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthState>(
            listenWhen: (previous, current) =>
                previous.status.isLoading && current.isAuthorized,
            listener: (context, _) {
              context.read<AuthCubit>().fetchMe();
              context.read<AuthCubit>().fetchCsrf();
            },
          ),
          BlocListener<SettingsCubit, SettingsState>(
            listenWhen: (previous, current) =>
                previous.status == SettingsStatus.loading &&
                current.status == SettingsStatus.success,
            listener: (context, state) {
              if (state.initialDeepLink.isNotEmpty) {
                /// Auto route delegate? криво шлет нас по путям с холодного
                /// старта, не подставляя корректный стэк в навигацию,
                /// поэтому в AutoRouterDelegate указываем initialDeepLink
                /// как "/", и в кубите через AppLinks получаем линк и с задержкой
                /// шлем по пути вот прямо тут, под этим комментарием
                Future.delayed(
                  const Duration(milliseconds: 1500),
                  () => router.navigateNamed(state.initialDeepLink),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            if (state.status == SettingsStatus.loading) {
              /// TODO: Splash Page
              return const Material(
                child: CircleIndicator(),
              );
            }

            return Listener(
              onPointerDown: (_) {
                // FocusScopeNode currentFocus = FocusScope.of(context);
                // if (!currentFocus.hasPrimaryFocus) {
                //   currentFocus.focusedChild?.unfocus();
                // }
              },
              child: MaterialApp.router(
                title: 'Flabr',
                // ignore: deprecated_member_use
                useInheritedMediaQuery: true,
                locale: DevicePreview.locale(context),
                themeMode: state.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
                theme: lightTheme(),
                darkTheme: darkTheme(),
                scrollBehavior: const MaterialScrollBehavior(),
                routerConfig: router.config(
                  deepLinkBuilder: (link) {
                    return link.initial
                        ? const DeepLink.path('/')
                        : DeepLink.none;
                  },
                ),
                builder: (context, child) {
                  return DevicePreview.appBuilder(
                    context,
                    ResponsiveBreakpoints.builder(
                      child: child ?? const SizedBox.shrink(),
                      breakpoints: [
                        const Breakpoint(
                          start: 0,
                          end: 600,
                          name: ScreenType.mobile,
                        ),
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
              ),
            );
          },
        ),
      ),
    );
  }
}
