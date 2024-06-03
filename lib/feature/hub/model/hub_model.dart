import 'package:equatable/equatable.dart';

import '../../../data/model/hub.dart';
import 'hub_related_data.dart';
import 'hub_statistics_model.dart';

class HubModel extends HubBase with EquatableMixin {
  const HubModel({
    required super.alias,
    super.titleHtml = '',
    super.imageUrl = '',
    super.descriptionHtml = '',
    super.isProfiled = false,
    super.isOfftop = false,
    super.relatedData = HubRelatedData.empty,
    super.statistics = HubStatisticsModel.empty,
    super.commonTags = const [],
  });

  @override
  HubModel copyWith({
    String? alias,
    String? titleHtml,
    String? imageUrl,
    String? descriptionHtml,
    bool? isProfiled,
    bool? isOfftop,
    HubRelatedData? relatedData,
    HubStatisticsModel? statistics,
    List<String>? commonTags,
  }) {
    return HubModel(
      alias: alias ?? this.alias,
      titleHtml: titleHtml ?? this.titleHtml,
      imageUrl: imageUrl ?? this.imageUrl,
      descriptionHtml: descriptionHtml ?? this.descriptionHtml,
      isProfiled: isProfiled ?? this.isProfiled,
      isOfftop: isOfftop ?? this.isOfftop,
      relatedData: relatedData ?? this.relatedData,
      statistics: statistics ?? this.statistics,
      commonTags: commonTags ?? this.commonTags,
    );
  }

  factory HubModel.fromMap(Map<String, dynamic> map) {
    return HubModel(
      alias: map['alias'] as String,
      titleHtml: map['titleHtml'] as String,
      imageUrl: map['imageUrl'] as String,
      descriptionHtml: map['descriptionHtml'] as String,
      isProfiled: map['isProfiled'] as bool,
      isOfftop: map['isOfftop'] as bool,
      relatedData: map['relatedData'] != null
          ? HubRelatedData.fromMap(map['relatedData'])
          : HubRelatedData.empty,
      statistics: map['statistics'] != null
          ? HubStatisticsModel.fromMap(map['statistics'])
          : HubStatisticsModel.empty,
      commonTags: map['commonTags'] != null
          ? List<String>.from(map['commonTags'])
          : const [],
    );
  }

  static const empty = HubModel(alias: '-');
  bool get isEmpty => this == empty;

  @override
  List<Object> get props {
    return [
      alias,
      titleHtml,
      imageUrl,
      descriptionHtml,
      isProfiled,
      isOfftop,
      relatedData,
      statistics,
      commonTags,
    ];
  }
}
