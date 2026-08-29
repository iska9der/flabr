import 'package:flutter/widgets.dart';

import '../../../i18n/i18n.dart';
import '../../exception/exception.dart';

enum Language {
  ru,
  en;

  static Language fromString(String value) {
    return switch (value) {
      'ru' => ru,
      'en' => en,
      _ => throw ValueException(t.language.unknown),
    };
  }

  Locale get locale => switch (this) {
    Language.ru => const Locale('ru', 'RU'),
    Language.en => const Locale('en', 'US'),
  };
  AppLocale get appLocale => switch (this) {
    Language.ru => AppLocale.ru,
    Language.en => AppLocale.en,
  };

  String get label => switch (this) {
    Language.ru => t.language.russian,
    Language.en => t.language.english,
  };
}
