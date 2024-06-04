part of 'publication.dart';

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
      author: map['author'] != null
          ? PublicationAuthor.fromMap(map['author'])
          : PublicationAuthor.empty,
      statistics: map['statistics'] != null
          ? PublicationStatistics.fromMap(map['statistics'])
          : PublicationStatistics.empty,
      relatedData: map['relatedData'] != null
          ? PublicationRelatedData.fromMap(map['relatedData'])
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
    );
  }

  static const empty = PublicationPost(id: '0');

  @override
  List<Object?> get props => [
        ...super.props,
      ];
}
