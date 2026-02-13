part of 'publication.dart';

@JsonEnum()
enum PublicationFormat {
  @JsonValue('case')
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
  retrospective
  ;

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
