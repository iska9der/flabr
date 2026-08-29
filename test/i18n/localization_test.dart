import 'package:flabr/bloc/error/app_failure.dart';
import 'package:flabr/data/exception/exception.dart';
import 'package:flabr/data/model/language/language.dart';
import 'package:flabr/i18n/i18n.dart' as app_localizations;
import 'package:flabr/presentation/extension/error.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ya_summary/i18n/i18n.dart' as summary_localizations;

void main() {
  setUp(() {
    app_localizations.LocaleSettings.setLocaleSync(
      app_localizations.AppLocale.ru,
    );
  });

  test('Language maps to the matching Slang locale', () {
    expect(Language.ru.appLocale, app_localizations.AppLocale.ru);
    expect(Language.en.appLocale, app_localizations.AppLocale.en);
  });
  test('failures are localized when presented', () {
    final failure = AppFailure(
      .companyProfileFetchFailed,
      Exception('network'),
    );

    expect(
      app_localizations.t.errorMessage(failure),
      'Не удалось получить профиль компании',
    );

    app_localizations.LocaleSettings.setLocaleSync(
      app_localizations.AppLocale.en,
    );

    expect(
      app_localizations.t.errorMessage(failure),
      'Failed to load the company profile',
    );
  });

  test('typed exceptions override operation fallback', () {
    const failure = AppFailure(
      .companyProfileFetchFailed,
      CommentsListException(400, 'POST_IN_DRAFTS'),
    );

    expect(
      app_localizations.t.errorMessage(failure),
      'Публикация в черновиках',
    );
  });

  testWidgets('providers rebuild both catalogs after locale change', (
    tester,
  ) async {
    await tester.pumpWidget(
      app_localizations.TranslationProvider(
        child: summary_localizations.TranslationProvider(
          child: Builder(
            builder: (context) {
              final translations = app_localizations.Translations.of(context);
              final summaryTranslations =
                  summary_localizations.YaSummaryTranslations.of(context);

              return Directionality(
                textDirection: TextDirection.ltr,
                child: Column(
                  children: [
                    Text(translations.shortcut.bookmarks),
                    Text(summaryTranslations.summary.token),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('Закладки'), findsOneWidget);
    expect(find.text('Токен'), findsOneWidget);

    app_localizations.LocaleSettings.setLocaleSync(
      app_localizations.AppLocale.en,
    );
    await tester.pumpAndSettle();

    expect(find.text('Bookmarks'), findsOneWidget);
    expect(find.text('Token'), findsOneWidget);
  });
}
