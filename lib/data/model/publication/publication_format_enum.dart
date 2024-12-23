import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

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
    if (value == 'case') {
      return PublicationFormat.example;
    }

    final format = PublicationFormat.values.firstWhereOrNull(
      (e) => e.name == value,
    );

    if (format == null) {
      debugPrint('Неизвестное значение для [ArticleFormat]');

      return null;
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

  Color get color => switch (this) {
        example || digest || opinion || review => const Color(0xff2385e7),
        faq || roadmap || tutorial => const Color(0xffd5700b),
        interview || reportage => const Color(0xff1da53d).withValues(alpha: .7),
        analytics || retrospective => const Color(0xffc23d96),
      };
}
