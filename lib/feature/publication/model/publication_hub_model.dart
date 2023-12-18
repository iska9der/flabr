import 'package:equatable/equatable.dart';

import '../../../common/model/hub.dart';
import '../../../common/model/hub_type.dart';
import '../../hub/model/hub_related_data.dart';

class PublicationHubModel extends HubBase with EquatableMixin {
  const PublicationHubModel({
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
  factory PublicationHubModel.fromMap(Map<String, dynamic> map) {
    return PublicationHubModel(
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

  static const empty = PublicationHubModel(id: '0');

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
