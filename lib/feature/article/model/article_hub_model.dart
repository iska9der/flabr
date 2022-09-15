import 'package:equatable/equatable.dart';

import '../../../common/model/hub.dart';
import '../../hub/model/hub_related_data.dart';
import 'article_hub_type.dart';

class ArticleHubModel extends HubBase with EquatableMixin {
  const ArticleHubModel({
    required this.id,
    super.alias = '',
    this.title = '',
    this.type = ArticleHubType.collective,
    super.isProfiled = false,
    HubRelatedData super.relatedData = HubRelatedData.empty,
  });

  final String id;
  final String title;
  final ArticleHubType type;

  @override
  factory ArticleHubModel.fromMap(Map<String, dynamic> map) {
    return ArticleHubModel(
      id: map['id'],
      alias: map['alias'] as String,
      title: map['title'] as String,
      type: ArticleHubType.fromString(map['type']),
      isProfiled: map['isProfiled'] as bool,
      relatedData: map['relatedData'] != null
          ? HubRelatedData.fromMap(map['relatedData'])
          : HubRelatedData.empty,
    );
  }

  static const empty = ArticleHubModel(id: '0');

  @override
  List<Object?> get props => [
        id,
        alias,
        title,
        type,
        relatedData,
        isProfiled,
      ];
}
