import 'package:injectable/injectable.dart';

const demo = Environment('demo');

abstract class AppEnvironment {
  /// варианты: prod, dev, demo, test
  static const env = String.fromEnvironment('ENV', defaultValue: 'prod');

  static const isDemo = env == 'demo';

  static const appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Flabr',
  );

  static const contactEmail = String.fromEnvironment(
    'CONTACT_EMAIL',
    defaultValue: 'example@gmail.com',
  );
  static const contactTelegram = String.fromEnvironment(
    'CONTACT_TG',
    defaultValue: 'username',
  );

  static bool isHostSafe(Uri uri) => [
    'habr.com',
    'm.habr.com',
    'm.habr.ru',
    'habrahabr.ru',
  ].any((safeHost) => safeHost == uri.host);
}
