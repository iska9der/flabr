import 'package:intl/intl.dart';

import '../data/model/language/language.dart';
import 'language_extension.dart';
import 'translations.g.dart';

/// Синхронизирует выбранную локаль между localization-системами приложения
abstract final class LocalizationManager {
  /// Применяет [language] к Slang и Intl
  static void setLocale(Language language) {
    LocaleSettings.setLocaleSync(language.appLocale);
    Intl.defaultLocale = language.locale.toString();
  }
}
