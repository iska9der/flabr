import 'package:flabr/bloc/error/app_failure.dart';
import 'package:flabr/data/exception/exception.dart';
import 'package:flabr/data/model/language/language.dart';
import 'package:flabr/i18n/i18n.dart' as app_localizations;
import 'package:flabr/i18n/language_extension.dart';
import 'package:flabr/presentation/extension/error.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart' show Intl;

void main() {
  setUp(() {
    app_localizations.LocalizationManager.setLocale(Language.ru);
  });

  test('Language extension maps the model to localization values', () {
    expect(Language.ru.appLocale, app_localizations.AppLocale.ru);
    expect(Language.en.appLocale, app_localizations.AppLocale.en);
    expect(Language.en.locale, const Locale('en', 'US'));
    expect(Language.en.label, app_localizations.t.language.english);
  });

  test('localization manager synchronizes Slang and Intl locales', () {
    app_localizations.LocalizationManager.setLocale(Language.en);

    expect(
      app_localizations.LocaleSettings.currentLocale,
      app_localizations.AppLocale.en,
    );
    expect(Intl.defaultLocale, 'en_US');
  });

  test('failures are localized when presented', () {
    final failure = AppFailure(
      .companyProfileFetchFailed,
      Exception('network'),
    );

    final russianMessage = app_localizations.t.errorMessage(failure);
    expect(
      russianMessage,
      app_localizations.t.company.profile.fetchFailed,
    );

    app_localizations.LocaleSettings.setLocaleSync(
      app_localizations.AppLocale.en,
    );

    final englishMessage = app_localizations.t.errorMessage(failure);
    expect(
      englishMessage,
      app_localizations.t.company.profile.fetchFailed,
    );
    expect(englishMessage, isNot(russianMessage));
  });

  test('typed exceptions override operation fallback', () {
    const failure = AppFailure(
      .companyProfileFetchFailed,
      CommentsListException(400, 'POST_IN_DRAFTS'),
    );

    expect(
      app_localizations.t.errorMessage(failure),
      app_localizations.t.comment.publication.inDrafts,
    );
  });

  test('not found exceptions use the common error message', () {
    expect(
      app_localizations.t.errorMessage(const NotFoundException()),
      app_localizations.t.error.notFound,
    );
    expect(
      app_localizations.t.errorMessage(
        const CommentsListException(404, 'NOT_FOUND'),
      ),
      app_localizations.t.error.notFound,
    );
  });

  test('missing MIME type uses the image-specific message', () {
    expect(
      app_localizations.t.errorMessage(const MissingMimeTypeException()),
      app_localizations.t.image.missingMimeType,
    );
  });

  test('unknown publication flow uses a localized typed error', () {
    const error = ValueException(ValueExceptionType.unknownPublicationFlow);

    final russianMessage = app_localizations.t.errorMessage(error);
    expect(russianMessage, app_localizations.t.publication.flow.unknown);

    app_localizations.LocaleSettings.setLocaleSync(
      app_localizations.AppLocale.en,
    );

    final englishMessage = app_localizations.t.errorMessage(error);
    expect(englishMessage, app_localizations.t.publication.flow.unknown);
    expect(englishMessage, isNot(russianMessage));
  });
}
