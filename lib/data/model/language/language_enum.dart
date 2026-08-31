import '../../exception/exception.dart';

enum Language {
  ru,
  en;

  static Language fromString(String value) {
    return switch (value) {
      'ru' => ru,
      'en' => en,
      _ => throw const ValueException(.unknownLanguage),
    };
  }
}
