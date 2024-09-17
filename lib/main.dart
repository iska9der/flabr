import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'core/component/bloc/observer.dart';
import 'core/component/di/injector.dart';
import 'core/component/logger/console.dart';
import 'presentation/app.dart';

void main() => runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();

        await configureDependencies();

        Intl.defaultLocale = 'ru_RU';
        await initializeDateFormatting('ru_RU');
        if (kDebugMode) {
          Bloc.observer = MyBlocObserver();
        }

        runApp(
          DevicePreview(
            // ignore: avoid_redundant_argument_values
            enabled: !kReleaseMode,
            builder: (_) => MyApp(router: getIt()),
          ),
        );
      },
      (error, stack) {
        if (kDebugMode) logger.error(error, stack);
      },
    );
