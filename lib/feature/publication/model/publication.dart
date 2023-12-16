import 'publication_author_model.dart';
import 'publication_hub_model.dart';
import 'publication_related_data_model.dart';
import 'publication_statistics_model.dart';
import 'publication_type.dart';

/// Базовая модель публикации с общими свойствами
class Publication {
  const Publication({
    required this.id,
    this.type = PublicationType.article,
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

  static const empty = Publication(id: '0');

  bool get isEmpty => this == empty;
}
