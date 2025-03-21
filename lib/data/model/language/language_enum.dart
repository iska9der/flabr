import 'package:flutter/widgets.dart';

import '../../exception/exception.dart';

enum Language {
  ru,
  en;

  static Language fromString(String value) {
    return switch (value) {
      'ru' => ru,
      'en' => en,
      _ => throw ValueException('Неизвестный язык'),
    };
  }

  Locale get locale => switch (this) {
    Language.ru => const Locale('ru', 'RU'),
    Language.en => const Locale('en', 'EN'),
  };

  String get label => switch (this) {
    Language.ru => 'Русский',
    Language.en => 'Английский',
  };
}
