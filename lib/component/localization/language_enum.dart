import '../../common/exception/value_exception.dart';

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
}
