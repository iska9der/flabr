abstract class AppEnvironment {
  /// варианты: prod, dev, test
  static const env = String.fromEnvironment('ENV', defaultValue: 'prod');

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
}
