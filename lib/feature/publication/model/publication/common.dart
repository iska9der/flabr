part of 'publication.dart';

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

  factory PublicationCommon.fromMap(Map<String, dynamic> map) {
    return PublicationCommon(
      id: map['id'],
      type: map.containsKey('publicationType')
          ? PublicationType.fromString(map['publicationType'])
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
