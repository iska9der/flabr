import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'component/di/dependencies.dart';
import 'component/router/router.gr.dart';
import 'component/storage/cache_storage.dart';
import 'component/theme/cubit/theme_cubit.dart';
import 'component/theme/theme.dart';

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
      create: (context) => ThemeCubit(getIt.get<CacheStorage>())..init(),
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Flabr',
            routerDelegate: router.delegate(),
            routeInformationParser: router.defaultRouteParser(),
            theme: state == true ? darkTheme() : lightTheme(),
          );
        },
      ),
    );
  }
}
