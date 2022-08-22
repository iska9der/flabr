import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'common/widget/progress_indicator.dart';
import 'component/di/dependencies.dart';
import 'component/router/router.gr.dart';
import 'component/storage/cache_storage.dart';
import 'component/theme/theme.dart';
import 'feature/settings/cubit/settings_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Залочить вертикальную ориентацию
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  setDependencies();

  runZonedGuarded(
    () => runApp(const MyApp()),
    (error, stack) {
      if (kDebugMode) print(error.toString());
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final router = getIt.get<AppRouter>();

    return BlocProvider(
      create: (c) => SettingsCubit(getIt.get<CacheStorage>())..init(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state.status == SettingsStatus.loading) {
            return const Material(child: CircleIndicator());
          }

          return MaterialApp.router(
            title: 'Flabr',
            routerDelegate: AutoRouterDelegate(router),
            routeInformationParser: router.defaultRouteParser(),
            theme: lightTheme(),
            darkTheme: darkTheme(),
            themeMode: state.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          );
        },
      ),
    );
  }
}
