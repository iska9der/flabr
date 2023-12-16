import 'package:equatable/equatable.dart';

import '../publication.dart';
import '../publication_author_model.dart';
import '../publication_hub_model.dart';
import '../publication_related_data_model.dart';
import '../publication_statistics_model.dart';
import '../publication_type.dart';

class PostModel extends Publication with EquatableMixin {
  const PostModel({
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

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'],
      type: PublicationType.post,
      timePublished: map['timePublished'],
      textHtml: map['textHtml'] ?? '',
      author: map['author'] != null
          ? PublicationAuthorModel.fromMap(map['author'])
          : PublicationAuthorModel.empty,
      statistics: map['statistics'] != null
          ? PublicationStatisticsModel.fromMap(map['statistics'])
          : PublicationStatisticsModel.empty,
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
    );
  }

  static const empty = PostModel(id: '0');

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
        publishedAt,
        isEmpty,
      ];
}
