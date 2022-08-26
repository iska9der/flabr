import 'package:flutter/material.dart';

import 'language_enum.dart';

extension LanguageX on LanguageEnum {
  Locale get locale {
    switch (this) {
      case LanguageEnum.ru:
        return const Locale('ru', 'RU');
      case LanguageEnum.en:
        return const Locale('en', 'EN');

      default:
        return const Locale('ru', 'RU');
    }
  }

  String get label {
    switch (this) {
      case LanguageEnum.ru:
        return 'Русский';
      case LanguageEnum.en:
        return 'Английский';
    }
  }
}
