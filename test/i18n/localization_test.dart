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
    expect(Language.en.label, 'Английский');
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

  test('not found exceptions use the common error message', () {
    expect(
      app_localizations.t.errorMessage(const NotFoundException()),
      'Не найдено',
    );
    expect(
      app_localizations.t.errorMessage(
        const CommentsListException(404, 'NOT_FOUND'),
      ),
      'Не найдено',
    );
  });

  test('missing MIME type uses the image-specific message', () {
    expect(
      app_localizations.t.errorMessage(const MissingMimeTypeException()),
      'В заголовках не указан mime/type',
    );
  });

  test('unknown publication flow uses a localized typed error', () {
    const error = ValueException(ValueExceptionType.unknownPublicationFlow);

    expect(
      app_localizations.t.errorMessage(error),
      'Неизвестный поток публикации',
    );

    app_localizations.LocaleSettings.setLocaleSync(
      app_localizations.AppLocale.en,
    );

    expect(
      app_localizations.t.errorMessage(error),
      'Unknown publication flow',
    );
  });

  test('feature labels are owned by their semantic domains', () {
    expect(app_localizations.t.services.hubs, 'Хабы');
    expect(app_localizations.t.company.dashboard.profile, 'Профиль');
    expect(app_localizations.t.hub.list.title, 'Хабы');
    expect(app_localizations.t.user.dashboard.publications, 'Публикации');
    expect(app_localizations.t.user.bookmarks.types.comments, 'Комментарии');
    expect(app_localizations.t.publication.dashboard.myFeed, 'Моя лента');
    expect(app_localizations.t.publication.complexity.easy, 'Простой');
    expect(app_localizations.t.publication.flow.development, 'Разработка');
    expect(app_localizations.t.publication.format.caseStudy, 'Кейс');
    expect(app_localizations.t.publication.type.article, 'Статья');
    expect(app_localizations.t.search.order.relevance, 'По релевантности');
    expect(app_localizations.t.tracker.publications.title, 'Публикации');
    expect(app_localizations.t.navigation.publications, 'Публикации');
    expect(app_localizations.t.profile.bookmarks, 'Закладки');
    expect(app_localizations.t.settings.title, 'Настройки');
    expect(
      app_localizations.t.settings.account.description,
      'Профиль и интеграции',
    );
    expect(
      app_localizations.t.settings.interface.theme.amoled.label,
      'AMOLED-режим',
    );
    expect(
      app_localizations.t.settings.fonts.typography.font.size,
      'Размер шрифта',
    );
    expect(
      app_localizations.t.settings.interface.navigation.alignment.center,
      'В центре',
    );
    expect(
      app_localizations.t.settings.feed.pageLoading.title,
      'Загрузка страниц',
    );
    expect(
      app_localizations.t.settings.feed.cards.title,
      'Видимость элементов',
    );
    expect(
      app_localizations.t.settings.publication.visibility.images,
      'Изображения',
    );

    app_localizations.LocaleSettings.setLocaleSync(
      app_localizations.AppLocale.en,
    );

    expect(app_localizations.t.services.hubs, 'Hubs');
    expect(app_localizations.t.company.dashboard.profile, 'Profile');
    expect(app_localizations.t.hub.list.title, 'Hubs');
    expect(app_localizations.t.user.dashboard.publications, 'Publications');
    expect(app_localizations.t.user.bookmarks.types.comments, 'Comments');
    expect(app_localizations.t.publication.dashboard.myFeed, 'My feed');
    expect(app_localizations.t.publication.complexity.easy, 'Easy');
    expect(app_localizations.t.publication.flow.development, 'Development');
    expect(app_localizations.t.publication.format.caseStudy, 'Case study');
    expect(app_localizations.t.publication.type.article, 'Article');
    expect(app_localizations.t.search.order.relevance, 'By relevance');
    expect(app_localizations.t.tracker.publications.title, 'Publications');
    expect(app_localizations.t.navigation.publications, 'Publications');
    expect(app_localizations.t.profile.bookmarks, 'Bookmarks');
    expect(app_localizations.t.settings.title, 'Settings');
    expect(
      app_localizations.t.settings.account.description,
      'Profile and integrations',
    );
    expect(
      app_localizations.t.settings.interface.theme.amoled.label,
      'AMOLED mode',
    );
    expect(
      app_localizations.t.settings.fonts.typography.font.size,
      'Font size',
    );
    expect(
      app_localizations.t.settings.interface.navigation.alignment.center,
      'In the center',
    );
    expect(
      app_localizations.t.settings.feed.pageLoading.title,
      'Page loading',
    );
    expect(
      app_localizations.t.settings.feed.cards.title,
      'Element visibility',
    );
    expect(
      app_localizations.t.settings.publication.visibility.images,
      'Images',
    );
  });

  testWidgets('provider rebuilds the app catalog after locale change', (
    tester,
  ) async {
    await tester.pumpWidget(
      app_localizations.TranslationProvider(
        child: Builder(
          builder: (context) {
            final translations = app_localizations.Translations.of(context);

            return Directionality(
              textDirection: TextDirection.ltr,
              child: Column(
                children: [
                  Text(translations.shortcut.bookmarks),
                  Text(translations.summary.token.label),
                ],
              ),
            );
          },
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
