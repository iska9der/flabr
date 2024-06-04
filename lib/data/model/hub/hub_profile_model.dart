import 'package:equatable/equatable.dart';

import '../hub_base.dart';
import '../publication/publication_flow_enum.dart';
import '../related_data/hub_related_data_model.dart';
import 'hub_statistics_model.dart';

class HubProfileModel extends HubBase with EquatableMixin {
  const HubProfileModel({
    required super.alias,
    required this.flow,
    super.titleHtml = '',
    super.descriptionHtml = '',
    this.fullDescriptionHtml = '',
    super.imageUrl = '',
    HubRelatedData super.relatedData = HubRelatedData.empty,
    super.statistics = HubStatisticsModel.empty,
    this.keywords = const [],
    super.isProfiled = false,
  });

  final String fullDescriptionHtml;
  final List<String> keywords;
  final PublicationFlow flow;

  @override
  HubStatisticsModel get statistics => super.statistics as HubStatisticsModel;

  @override
  HubProfileModel copyWith({
    String? alias,
    PublicationFlow? flow,
    String? titleHtml,
    String? descriptionHtml,
    String? fullDescriptionHtml,
    String? imageUrl,
    HubRelatedData? relatedData,
    HubStatisticsModel? statistics,
    List<String>? keywords,
    bool? isProfiled,
  }) {
    return HubProfileModel(
      alias: alias ?? this.alias,
      flow: flow ?? this.flow,
      titleHtml: titleHtml ?? this.titleHtml,
      descriptionHtml: descriptionHtml ?? this.descriptionHtml,
      fullDescriptionHtml: fullDescriptionHtml ?? this.fullDescriptionHtml,
      imageUrl: imageUrl ?? this.imageUrl,
      relatedData: relatedData ?? this.relatedData as HubRelatedData,
      statistics: statistics ?? this.statistics,
      keywords: keywords ?? this.keywords,
      isProfiled: isProfiled ?? this.isProfiled,
    );
  }

  factory HubProfileModel.fromMap(Map<String, dynamic> map) {
    return HubProfileModel(
      alias: map['alias'] as String,
      flow: PublicationFlow.fromString(map['flow']['alias']),
      titleHtml: map['titleHtml'] as String,
      descriptionHtml: map['descriptionHtml'] as String,
      fullDescriptionHtml: map['fullDescriptionHtml'] as String,
      imageUrl: map['imageUrl'] as String,
      relatedData: map['relatedData'] != null
          ? HubRelatedData.fromMap(map['relatedData'])
          : HubRelatedData.empty,
      statistics: map['statistics'] != null
          ? HubStatisticsModel.fromMap(map['statistics'])
          : HubStatisticsModel.empty,
      keywords: map['keywords'] != null
          ? List<String>.from(map['keywords'])
          : const [],
      isProfiled: map['isProfiled'] as bool,
    );
  }

  static const empty = HubProfileModel(alias: '-', flow: PublicationFlow.all);
  bool get isEmpty => this == empty;

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        alias,
        flow,
        titleHtml,
        descriptionHtml,
        fullDescriptionHtml,
        imageUrl,
        relatedData,
        statistics,
        keywords,
        isProfiled,
        isOfftop,
        commonTags,
      ];
}
