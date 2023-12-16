import 'package:equatable/equatable.dart';

import 'lead/publication_lead_data_model.dart';
import 'publication.dart';
import 'publication_author_model.dart';
import 'publication_complexity.dart';
import 'publication_format.dart';
import 'publication_hub_model.dart';
import 'publication_related_data_model.dart';
import 'publication_statistics_model.dart';
import 'publication_type.dart';

class CommonModel extends Publication with EquatableMixin {
  const CommonModel({
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
  final PublicationComplexity? complexity;
  final int readingTime;
  final PublicationFormat? format;

  factory CommonModel.fromMap(Map<String, dynamic> map) {
    return CommonModel(
      id: map['id'],
      type: map.containsKey('postType')
          ? PublicationType.fromString(map['postType'])
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
          ? PublicationComplexity.fromString(map['complexity'])
          : null,
      readingTime: map['readingTime'] ?? 0,
      format: map['format'] != null
          ? PublicationFormat.fromString(map['format'])
          : null,
    );
  }

  static const empty = CommonModel(id: '0');

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
        isEmpty,
      ];
}
