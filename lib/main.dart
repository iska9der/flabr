import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'bootstrap.dart';
import 'core/component/logger/logger.dart';
import 'presentation/app.dart';

void main() {
  final logger = ConsoleLogger();

  runZonedGuarded(
    () async {
      final binding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: binding);

      await Bootstrap.init(logger: logger);

      const AppConfig config = kDebugMode ? .dev : .prod;

      runApp(const Application(config: config));
    },
    (error, stack) {
      logger.error('Ошибка', error, stack);
    },
  );
}
