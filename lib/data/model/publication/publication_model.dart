import 'dart:collection';

import 'package:equatable/equatable.dart';

import 'publication_author_model.dart';
import 'publication_complexity_enum.dart';
import 'publication_format_enum.dart';
import 'publication_hub_model.dart';
import 'publication_lead_data_model.dart';
import 'publication_related_data_model.dart';
import 'publication_statistics_model.dart';
import 'publication_type_enum.dart';

/// Базовый класс с общими свойствами
sealed class Publication extends Equatable {
  const Publication({
    required this.id,
    this.type = PublicationType.unknown,
    this.timePublished = '2022-12-22T10:10:00+00:00',
    this.textHtml = '',
    this.author = PublicationAuthor.empty,
    this.statistics = PublicationStatistics.empty,
    this.relatedData = PublicationRelatedData.empty,
    this.hubs = const [],
    this.tags = const [],
  });

  final String id;
  final PublicationType type;

  final String timePublished;
  DateTime get publishedAt => DateTime.parse(timePublished).toLocal();

  final String textHtml;

  final PublicationAuthor author;
  final PublicationStatistics statistics;
  final PublicationRelatedData relatedData;

  final List<PublicationHub> hubs;
  final List<String> tags;

  static const empty = PublicationCommon(id: '0');
  bool get isEmpty => this == empty;

  @override
  List<Object?> get props => [
    id,
    type,
    timePublished,
    textHtml,
    author,
    statistics,
    relatedData,
    hubs,
    tags,
  ];

  factory Publication.fromMap(Map<String, dynamic> map) {
    final type =
        map.containsKey('publicationType')
            ? PublicationType.fromString(map['publicationType'])
            : PublicationType.unknown;

    return switch (type) {
      PublicationType.article => PublicationCommon.fromMap(map),
      PublicationType.news => PublicationCommon.fromMap(map),
      PublicationType.post => PublicationPost.fromMap(map),
      _ => const PublicationCommon(id: '0'),
    };
  }
}

/// Общий класс для статей и новостей, так как у них идентичные свойства
class PublicationCommon extends Publication {
  const PublicationCommon({
    required super.id,
    super.type,
    super.timePublished,
    super.textHtml,
    super.author,
    super.statistics,
    super.relatedData,
    super.hubs,
    super.tags,
    this.titleHtml = '',
    this.leadData = PublicationLeadData.empty,
    this.complexity,
    this.readingTime = 0,
    this.format,
  });

  final String titleHtml;
  final PublicationLeadData leadData;
  final PublicationComplexity? complexity;
  final int readingTime;
  final PublicationFormat? format;

  factory PublicationCommon.fromMap(Map<String, dynamic> map) {
    return PublicationCommon(
      id: map['id'],
      type:
          map.containsKey('publicationType')
              ? PublicationType.fromString(map['publicationType'])
              : map.containsKey('postType')
              ? PublicationType.fromString(map['postType'])
              : PublicationType.unknown,
      timePublished: map['timePublished'],
      textHtml: map['textHtml'] ?? '',
      author:
          map['author'] != null
              ? PublicationAuthor.fromMap(map['author'])
              : PublicationAuthor.empty,
      statistics:
          map['statistics'] != null
              ? PublicationStatistics.fromJson(map['statistics'])
              : PublicationStatistics.empty,
      relatedData:
          map['relatedData'] != null
              ? PublicationRelatedData.fromJson(map['relatedData'])
              : PublicationRelatedData.empty,
      hubs: UnmodifiableListView(
        List.from(map['hubs'] ?? []).map((e) => PublicationHub.fromMap(e)),
      ),
      tags: UnmodifiableListView(
        List.from(map['tags'] ?? []).map((tag) => tag['titleHtml']),
      ),

      /// добавленные поля
      titleHtml: map['titleHtml'] ?? '',
      leadData:
          map['leadData'] != null
              ? PublicationLeadData.fromMap(map['leadData'])
              : PublicationLeadData.empty,
      complexity:
          map['complexity'] != null
              ? PublicationComplexity.fromString(map['complexity'])
              : null,
      readingTime: map['readingTime'] ?? 0,
      format:
          map['format'] != null
              ? PublicationFormat.fromString(map['format'])
              : null,
    );
  }

  static const empty = PublicationCommon(id: '0');

  @override
  List<Object?> get props => [
    ...super.props,
    titleHtml,
    leadData,
    complexity,
    readingTime,
    format,
  ];
}

/// Класс для публикации с типом "Пост"
class PublicationPost extends Publication {
  const PublicationPost({
    required super.id,
    super.type,
    super.timePublished,
    super.textHtml,
    super.author,
    super.statistics,
    super.relatedData,
    super.hubs,
    super.tags,
  });

  factory PublicationPost.fromMap(Map<String, dynamic> map) {
    return PublicationPost(
      id: map['id'],
      type: PublicationType.post,
      timePublished: map['timePublished'],
      textHtml: map['textHtml'] ?? '',
      author:
          map['author'] != null
              ? PublicationAuthor.fromMap(map['author'])
              : PublicationAuthor.empty,
      statistics:
          map['statistics'] != null
              ? PublicationStatistics.fromJson(map['statistics'])
              : PublicationStatistics.empty,
      relatedData:
          map['relatedData'] != null
              ? PublicationRelatedData.fromJson(map['relatedData'])
              : PublicationRelatedData.empty,
      hubs: UnmodifiableListView(
        List.from(map['hubs'] ?? []).map((e) => PublicationHub.fromMap(e)),
      ),
      tags: UnmodifiableListView(
        List.from(map['tags'] ?? []).map((tag) => tag['titleHtml']),
      ),
    );
  }

  static const empty = PublicationPost(id: '0');

  @override
  List<Object?> get props => [...super.props];
}
