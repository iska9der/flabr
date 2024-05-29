import 'package:equatable/equatable.dart';

import '../lead/publication_lead_data_model.dart';
import '../publication_author_model.dart';
import '../publication_complexity.dart';
import '../publication_format.dart';
import '../publication_hub_model.dart';
import '../publication_related_data_model.dart';
import '../publication_statistics_model.dart';
import '../publication_type.dart';

part 'common.dart';
part 'post.dart';

/// Базовый класс с общими свойствами
sealed class Publication extends Equatable {
  const Publication({
    required this.id,
    this.type = PublicationType.unknown,
    this.timePublished = '2022-12-22T10:10:00+00:00',
    this.textHtml = '',
    this.author = PublicationAuthorModel.empty,
    this.statistics = PublicationStatisticsModel.empty,
    this.relatedData = PublicationRelatedDataModel.empty,
    this.hubs = const [],
    this.tags = const [],
  });

  final String id;
  final PublicationType type;

  final String timePublished;
  DateTime get publishedAt => DateTime.parse(timePublished).toLocal();

  final String textHtml;

  final PublicationAuthorModel author;
  final PublicationStatisticsModel statistics;
  final PublicationRelatedDataModel relatedData;

  final List<PublicationHubModel> hubs;
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
