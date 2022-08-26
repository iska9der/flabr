import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'common/widget/progress_indicator.dart';
import 'component/di/dependencies.dart';
import 'component/router/app_router.dart';
import 'component/storage/cache_storage.dart';
import 'component/theme.dart';
import 'feature/settings/cubit/settings_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Залочить вертикальную ориентацию
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  setDependencies();

  runZonedGuarded(
    () => runApp(MyApp()),
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
    return BlocProvider(
      create: (c) => SettingsCubit(
        storage: getIt.get<CacheStorage>(),
        router: getIt.get<AppRouter>(),
        appLinks: getIt.get<AppLinks>(),
      )..init(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state.status == SettingsStatus.loading) {
            /// todo: Splash Page
            return const Material(
              child: CircleIndicator(),
            );
          }

          return MaterialApp.router(
            title: 'Flabr',
            routerDelegate: AutoRouterDelegate(
              router,
              initialDeepLink: state.initialDeepLink,
            ),
            routeInformationParser: router.defaultRouteParser(
              includePrefixMatches: true,
            ),
            theme: lightTheme(),
            darkTheme: darkTheme(),
            themeMode: state.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          );
        },
      ),
    );
  }
}
