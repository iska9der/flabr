import '../../common/exception/value_exception.dart';

enum LanguageEnum {
  ru,
  en;

  static LanguageEnum fromString(String value) {
    switch (value) {
      case 'ru':
        return ru;
      case 'en':
        return en;
      default:
        throw ValueException('Неизвестный язык');
    }
  }
}
