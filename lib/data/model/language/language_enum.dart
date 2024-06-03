part of 'part.dart';

enum LanguageEnum {
  ru,
  en;

  static LanguageEnum fromString(String value) {
    return switch (value) {
      'ru' => ru,
      'en' => en,
      _ => throw ValueException('Неизвестный язык')
    };
  }

  Locale get locale => switch (this) {
        LanguageEnum.ru => const Locale('ru', 'RU'),
        LanguageEnum.en => const Locale('en', 'EN'),
      };

  String get label => switch (this) {
        LanguageEnum.ru => 'Русский',
        LanguageEnum.en => 'Английский'
      };
}
