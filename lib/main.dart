import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'component/bloc/observer.dart';
import 'component/di/dependencies.dart';
import 'component/router/app_router.dart';
import 'component/storage/cache_storage.dart';
import 'component/theme.dart';
import 'feature/auth/cubit/auth_cubit.dart';
import 'feature/auth/service/auth_service.dart';
import 'feature/settings/cubit/settings_cubit.dart';
import 'widget/progress_indicator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Залочить вертикальную ориентацию
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  setDependencies();

  Intl.defaultLocale = 'ru_RU';
  await initializeDateFormatting('ru_RU');

  runZonedGuarded(
    () {
      if (kDebugMode) {
        Bloc.observer = MyBlocObserver();
      }

      runApp(MyApp());
    },
    (error, stack) {
      if (kDebugMode) print(error.toString());
    },
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final AppRouter router = getIt.get<AppRouter>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (c) => SettingsCubit(
            storage: getIt.get<CacheStorage>(),
            router: getIt.get<AppRouter>(),
            appLinks: getIt.get<AppLinks>(),
          )..init(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => AuthCubit(
            storage: getIt.get<CacheStorage>(),
            service: getIt.get<AuthService>(),
          )..init(),
        ),
      ],
      child: BlocConsumer<SettingsCubit, SettingsState>(
        listenWhen: (p, current) =>
            p.status == SettingsStatus.loading &&
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
        builder: (context, state) {
          if (state.status == SettingsStatus.loading) {
            /// todo: Splash Page
            return const Material(
              child: CircleIndicator(),
            );
          }

          return MaterialApp.router(
            title: 'Flabr',
            routerDelegate: AutoRouterDelegate(router, initialDeepLink: '/'),
            routeInformationParser: router.defaultRouteParser(
              includePrefixMatches: true,
            ),
            theme: state.isDarkTheme ? darkTheme() : lightTheme(),
          );
        },
      ),
    );
  }
}
