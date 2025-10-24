import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'bootstrap.dart';
import 'core/component/logger/logger.dart';
import 'presentation/app.dart';

void main() => runZonedGuarded(
  () async {
    final binding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: binding);

    await Bootstrap.init();

    runApp(const Application());
  },
  (error, stack) {
    logger.error('Ошибка', error, stack);
  },
);
