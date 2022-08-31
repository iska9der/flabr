import 'package:equatable/equatable.dart';

import '../../../common/model/hub.dart';
import '../../article/model/flow_enum.dart';
import 'hub_statistics_model.dart';

class HubProfileModel extends HubBase with EquatableMixin {
  const HubProfileModel({
    required super.alias,
    required this.flow,
    super.titleHtml = '',
    super.descriptionHtml = '',
    this.fullDescriptionHtml = '',
    super.imageUrl = '',
    super.relatedData = const {},
    super.statistics = HubStatisticsModel.empty,
    this.keywords = const [],
    super.isProfiled = false,
  });

  final String fullDescriptionHtml;
  final List<String> keywords;
  final FlowEnum flow;

  @override
  HubStatisticsModel get statistics => super.statistics as HubStatisticsModel;

  @override
  HubProfileModel copyWith({
    String? alias,
    FlowEnum? flow,
    String? titleHtml,
    String? descriptionHtml,
    String? fullDescriptionHtml,
    String? imageUrl,
    Map? relatedData,
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
      relatedData: relatedData ?? this.relatedData,
      statistics: statistics ?? this.statistics,
      keywords: keywords ?? this.keywords,
      isProfiled: isProfiled ?? this.isProfiled,
    );
  }

  factory HubProfileModel.fromMap(Map<String, dynamic> map) {
    return HubProfileModel(
      alias: map['alias'] as String,
      flow: FlowEnum.fromString(map['flow']['alias']),
      titleHtml: map['titleHtml'] as String,
      descriptionHtml: map['descriptionHtml'] as String,
      fullDescriptionHtml: map['fullDescriptionHtml'] as String,
      imageUrl: map['imageUrl'] as String,
      relatedData: map['relatedData'] ?? const {},
      statistics: map['statistics'] != null
          ? HubStatisticsModel.fromMap(map['statistics'])
          : HubStatisticsModel.empty,
      keywords: map['keywords'] != null
          ? List<String>.from(map['keywords'])
          : const [],
      isProfiled: map['isProfiled'] as bool,
    );
  }

  static const empty = HubProfileModel(alias: '-', flow: FlowEnum.all);
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
      ];
}
