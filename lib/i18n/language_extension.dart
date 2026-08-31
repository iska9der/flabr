import 'package:flutter/widgets.dart';

import '../data/model/language/language.dart';
import 'translations.g.dart';

/// Адаптирует [Language] к Flutter и Slang localization API
extension LanguageExtension on Language {
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
