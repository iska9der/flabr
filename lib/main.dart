import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'core/component/bloc/observer.dart';
import 'core/component/di/injector.dart';
import 'core/component/logger/console.dart';
import 'presentation/widget/app.dart';

void main() async => runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();

        /// Залочить вертикальную ориентацию
        await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp],
        );

        configureDependencies();

        Intl.defaultLocale = 'ru_RU';
        await initializeDateFormatting('ru_RU');
        if (kDebugMode) {
          Bloc.observer = MyBlocObserver();
        }

        runApp(
          DevicePreview(
            // ignore: avoid_redundant_argument_values
            enabled: !kReleaseMode,
            builder: (_) => MyApp(),
          ),
        );
      },
      (error, stack) {
        if (kDebugMode) logger.error(error, stack);
      },
    );
