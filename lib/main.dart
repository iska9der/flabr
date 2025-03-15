import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/component/di/injector.dart';
import 'core/component/logger/console.dart';
import 'core/helper/helper.dart';
import 'presentation/app.dart';

void main() => runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();

        await AppInitializer.init();

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
