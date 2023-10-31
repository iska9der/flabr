import 'package:equatable/equatable.dart';

import '../../../common/model/hub.dart';
import '../../../common/model/hub_type.dart';
import '../../hub/model/hub_related_data.dart';

class ArticleHubModel extends HubBase with EquatableMixin {
  const ArticleHubModel({
    required this.id,
    super.alias = '',
    this.title = '',
    this.type = HubType.collective,
    super.isProfiled = false,
    HubRelatedData super.relatedData = HubRelatedData.empty,
  });

  final String id;
  final String title;
  final HubType type;

  @override
  factory ArticleHubModel.fromMap(Map<String, dynamic> map) {
    return ArticleHubModel(
      id: map['id'],
      alias: map['alias'] as String,
      title: map['title'] as String,
      type: HubType.fromString((map['type'] ?? 'collective')),
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
        titleHtml,
        imageUrl,
        descriptionHtml,
        isOfftop,
        statistics,
        commonTags,
      ];
}
