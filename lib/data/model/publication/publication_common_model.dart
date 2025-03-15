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
      type: map.containsKey('publicationType')
          ? PublicationType.fromString(map['publicationType'])
          : map.containsKey('postType')
              ? PublicationType.fromString(map['postType'])
              : PublicationType.unknown,
      timePublished: map['timePublished'],
      textHtml: map['textHtml'] ?? '',
      author: map['author'] != null
          ? PublicationAuthor.fromMap(map['author'])
          : PublicationAuthor.empty,
      statistics: map['statistics'] != null
          ? PublicationStatistics.fromJson(map['statistics'])
          : PublicationStatistics.empty,
      relatedData: map['relatedData'] != null
          ? PublicationRelatedData.fromJson(map['relatedData'])
          : PublicationRelatedData.empty,
      hubs: map['hubs'] != null
          ? List<PublicationHub>.from(
              map['hubs'].map((e) => PublicationHub.fromMap(e)),
            ).toList()
          : const [],
      tags: map.containsKey('tags')
          ? List<String>.from(map['tags'].map((tag) => tag['titleHtml']))
              .toList()
          : const [],

      /// добавленные поля
      titleHtml: map['titleHtml'] ?? '',
      leadData: map['leadData'] != null
          ? PublicationLeadData.fromMap(map['leadData'])
          : PublicationLeadData.empty,
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
