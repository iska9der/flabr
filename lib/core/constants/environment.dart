abstract class AppEnvironment {
  /// варианты: prod, test
  static const env = String.fromEnvironment(
    'ENV',
    defaultValue: 'prod',
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
