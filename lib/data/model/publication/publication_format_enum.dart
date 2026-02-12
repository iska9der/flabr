part of 'publication.dart';

enum PublicationFormat {
  example,
  tutorial,
  faq,
  review,
  opinion,
  digest,
  analytics,
  roadmap,
  reportage,
  interview,
  retrospective;

  static PublicationFormat? fromString(String value) {
    /// а все потому, что "case" зарезервировано языком!
    if (value == 'case') return PublicationFormat.example;

    final format = PublicationFormat.values.firstWhereOrNull(
      (e) => e.name == value,
    );

    if (format == null) {
      logger.warning('Неизвестное значение ArticleFormat: $value');
    }

    return format;
  }

  String get label => switch (this) {
    example => 'Кейс',
    tutorial => 'Туториал',
    faq => 'FAQ',
    review => 'Обзор',
    opinion => 'Мнение',
    digest => 'Дайджест',
    analytics => 'Аналитика',
    roadmap => 'Дорожная карта',
    reportage => 'Репортаж',
    interview => 'Интервью',
    retrospective => 'Ретроспектива',
  };
}
