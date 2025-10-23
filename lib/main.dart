import 'dart:async';

import 'package:flutter/material.dart';

import 'bootstrap.dart';
import 'core/component/logger/logger.dart';
import 'presentation/app.dart';

void main() => runZonedGuarded(
  () async {
    WidgetsFlutterBinding.ensureInitialized();

    await Bootstrap.init();

    runApp(const Application());
  },
  (error, stack) {
    logger.error('Ошибка', error, stack);
  },
);
