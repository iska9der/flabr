import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'common/model/extension/enum_status.dart';
import 'common/widget/enhancement/progress_indicator.dart';
import 'component/bloc/observer.dart';
import 'component/di/dependencies.dart';
import 'component/logger/console.dart';
import 'component/router/app_router.dart';
import 'component/storage/cache_storage.dart';
import 'component/theme.dart';
import 'feature/auth/cubit/auth_cubit.dart';
import 'feature/auth/repository/auth_repository.dart';
import 'feature/auth/repository/token_repository.dart';
import 'feature/settings/cubit/settings_cubit.dart';
import 'feature/settings/repository/language_repository.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      /// Залочить вертикальную ориентацию
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp]);

      setDependencies();

      Intl.defaultLocale = 'ru_RU';
      await initializeDateFormatting('ru_RU');
      if (kDebugMode) {
        Bloc.observer = MyBlocObserver();
      }

      runApp(MyApp());
    },
    (error, stack) {
      if (kDebugMode) ConsoleLogger.error(error, stack);
    },
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppRouter router = getIt.get<AppRouter>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (_) => SettingsCubit(
            languageRepository: getIt.get<LanguageRepository>(),
            storage: getIt.get<CacheStorage>(),
            router: router,
            appLinks: getIt.get<AppLinks>(),
          )..init(),
        ),
        BlocProvider(
          lazy: false,
          create: (_) => AuthCubit(
            repository: getIt.get<AuthRepository>(),
            tokenRepository: getIt.get<TokenRepository>(),
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
              /// todo: Splash Page
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
                routerConfig: router.config(
                  deepLinkBuilder: (deepLink) {
                    return const DeepLink.path('/');
                  },
                ),
                theme: state.isDarkTheme ? darkTheme() : lightTheme(),
              ),
            );
          },
        ),
      ),
    );
  }
}
