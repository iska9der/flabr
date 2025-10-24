import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'bloc/observer.dart';
import 'core/constants/constants.dart';
import 'di/di.dart';
import 'presentation/constants/constants.dart';
import 'presentation/helper/helper.dart';

abstract class Bootstrap {
  static Future<void> init() async {
    await configureDependencies(env: AppEnvironment.env);

    await loadIntl();

    AssetHelper.loadLicense();

    await AssetHelper.preloadAssets([
      const AssetImage(IconsAssets.logoWithBackground),
    ]);

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
}
