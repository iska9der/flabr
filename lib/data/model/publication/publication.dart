import 'package:equatable/equatable.dart';

import '../related_data/publication_related_data_model.dart';
import 'publication_author_model.dart';
import 'publication_complexity_enum.dart';
import 'publication_format_enum.dart';
import 'publication_hub_model.dart';
import 'publication_lead_data_model.dart';
import 'publication_statistics_model.dart';
import 'publication_type_enum.dart';

part 'publication_common_model.dart';
part 'publication_post_model.dart';

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
    final type = map.containsKey('publicationType')
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
