import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'bloc/observer.dart';
import 'core/constants/constants.dart';
import 'di/di.dart';

abstract class Bootstrap {
  static Future<void> init() async {
    await configureDependencies(env: AppEnvironment.env);

    await loadIntl();

    loadLicense();

    if (kDebugMode) {
      Bloc.observer = MyBlocObserver();
    }

    if (!kIsWeb && Platform.isAndroid) {
      /// максимальная герцовка
      /// issue https://github.com/flutter/flutter/issues/35162
      FlutterDisplayMode.setHighRefreshRate().ignore();
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
