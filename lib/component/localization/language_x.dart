import 'package:flutter/material.dart';

import 'language_enum.dart';

extension LanguageX on LanguageEnum {
  Locale get locale => switch (this) {
        LanguageEnum.ru => const Locale('ru', 'RU'),
        LanguageEnum.en => const Locale('en', 'EN'),
      };

  String get label => switch (this) {
        LanguageEnum.ru => 'Русский',
        LanguageEnum.en => 'Английский'
      };
}
