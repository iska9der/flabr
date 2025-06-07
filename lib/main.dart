import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'bootstrap.dart';
import 'core/component/logger/logger.dart';
import 'presentation/app.dart';

void main() => runZonedGuarded(
  () async {
    WidgetsFlutterBinding.ensureInitialized();

    await Bootstrap.init();

    runApp(
      DevicePreview(
        // ignore: avoid_redundant_argument_values
        enabled: !kReleaseMode,
        builder: (_) => const Application(),
      ),
    );
  },
  (error, stack) {
    logger.error(error, stack);
  },
);
