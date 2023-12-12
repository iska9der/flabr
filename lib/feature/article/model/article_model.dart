import 'package:equatable/equatable.dart';

import '../../publication/model/lead/publication_lead_data_model.dart';
import '../../publication/model/publication.dart';
import '../../publication/model/publication_author_model.dart';
import '../../publication/model/publication_hub_model.dart';
import '../../publication/model/publication_related_data_model.dart';
import '../../publication/model/publication_statistics_model.dart';
import '../../publication/model/publication_type.dart';
import 'article_complexity.dart';
import 'article_format.dart';

class ArticleModel extends Publication with EquatableMixin {
  const ArticleModel({
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
    this.leadData = PublicationLeadDataModel.empty,
    this.complexity,
    this.readingTime = 0,
    this.format,
  });

  final String titleHtml;
  final PublicationLeadDataModel leadData;
  final ArticleComplexity? complexity;
  final int readingTime;
  final ArticleFormat? format;

  factory ArticleModel.fromMap(Map<String, dynamic> map) {
    return ArticleModel(
      id: map['id'],
      type: map.containsKey('postType') || map.containsKey('publicationType')
          ? PublicationType.fromString(
              map['postType'] ?? map['publicationType'])
          : PublicationType.article,
      timePublished: map['timePublished'],
      titleHtml: map['titleHtml'] ?? '',
      textHtml: map['textHtml'] ?? '',
      author: map['author'] != null
          ? PublicationAuthorModel.fromMap(map['author'])
          : PublicationAuthorModel.empty,
      statistics: map['statistics'] != null
          ? PublicationStatisticsModel.fromMap(map['statistics'])
          : PublicationStatisticsModel.empty,
      leadData: map['leadData'] != null
          ? PublicationLeadDataModel.fromMap(map['leadData'])
          : PublicationLeadDataModel.empty,
      relatedData: map['relatedData'] != null
          ? PublicationRelatedDataModel.fromMap(map['relatedData'])
          : PublicationRelatedDataModel.empty,
      hubs: map['hubs'] != null
          ? List<PublicationHubModel>.from(
              map['hubs'].map((e) => PublicationHubModel.fromMap(e)),
            ).toList()
          : const [],
      tags: map.containsKey('tags')
          ? List<String>.from(map['tags'].map((tag) => tag['titleHtml']))
              .toList()
          : const [],
      complexity: map['complexity'] != null
          ? ArticleComplexity.fromString(map['complexity'])
          : null,
      readingTime: map['readingTime'] ?? 0,
      format: map['format'] != null
          ? ArticleFormat.fromString(map['format'])
          : null,
    );
  }

  static const empty = ArticleModel(id: '0');

  bool get isEmpty => this == empty;

  @override
  List<Object?> get props => [
        id,
        type,
        timePublished,
        titleHtml,
        textHtml,
        author,
        statistics,
        leadData,
        relatedData,
        hubs,
        tags,
        complexity,
        readingTime,
        format,
        publishedAt,
      ];
}
