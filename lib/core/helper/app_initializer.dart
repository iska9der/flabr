import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../di/di.dart';
import '../component/bloc/observer.dart';
import '../constants/constants.dart';

abstract class AppInitializer {
  static Future<void> init() async {
    await configureDependencies(env: AppEnvironment.env);

    await loadIntl();

    loadLicense();

    if (kDebugMode) {
      Bloc.observer = MyBlocObserver();
    }

    if (Platform.isAndroid) {
      /// максимальная герцовка
      /// issue https://github.com/flutter/flutter/issues/35162
      await FlutterDisplayMode.setHighRefreshRate();
    }
  }

  static Future<void> loadIntl([String defaultLocale = 'ru_RU']) async {
    Intl.defaultLocale = defaultLocale;
    await initializeDateFormatting(defaultLocale);
  }

  static void loadLicense() => LicenseRegistry.addLicense(() async* {
    final geologica = await rootBundle.loadString(LicenseAssets.fontGeologica);
    yield LicenseEntryWithLineBreaks(['flabr'], geologica);
  });
}
