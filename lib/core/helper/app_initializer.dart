part of 'helper.dart';

abstract class AppInitializer {
  static Future<void> init() async {
    await configureDependencies();
    await AppInitializer.loadIntl();
    AppInitializer.loadLicense();

    if (kDebugMode) {
      Bloc.observer = MyBlocObserver();
    }
  }

  static Future<void> loadIntl([String defaultLocale = 'ru_RU']) async {
    Intl.defaultLocale = defaultLocale;
    await initializeDateFormatting(defaultLocale);
  }

  static void loadLicense() {
    LicenseRegistry.addLicense(() async* {
      final geologica = await rootBundle.loadString(
        LicenseAssets.fontGeologica,
      );
      yield LicenseEntryWithLineBreaks(['flabr'], geologica);
    });
  }
}
