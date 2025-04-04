import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../hub_base.dart';
import 'hub_related_data_model.dart';
import 'hub_statistics_model.dart';

class Hub extends HubBase with EquatableMixin {
  const Hub({
    required super.alias,
    super.titleHtml = '',
    super.imageUrl = '',
    super.descriptionHtml = '',
    super.isProfiled = false,
    super.isOfftop = false,
    super.relatedData = HubRelatedData.empty,
    super.statistics = HubStatistics.empty,
    super.commonTags = const [],
  });

  @override
  Hub copyWith({
    String? alias,
    String? titleHtml,
    String? imageUrl,
    String? descriptionHtml,
    bool? isProfiled,
    bool? isOfftop,
    HubRelatedData? relatedData,
    HubStatistics? statistics,
    List<String>? commonTags,
  }) {
    return Hub(
      alias: alias ?? this.alias,
      titleHtml: titleHtml ?? this.titleHtml,
      imageUrl: imageUrl ?? this.imageUrl,
      descriptionHtml: descriptionHtml ?? this.descriptionHtml,
      isProfiled: isProfiled ?? this.isProfiled,
      isOfftop: isOfftop ?? this.isOfftop,
      relatedData: relatedData ?? this.relatedData,
      statistics: statistics ?? this.statistics,
      commonTags: UnmodifiableListView(commonTags ?? this.commonTags),
    );
  }

  factory Hub.fromMap(Map<String, dynamic> map) {
    return Hub(
      alias: map['alias'] as String,
      titleHtml: map['titleHtml'] as String,
      imageUrl: map['imageUrl'] as String,
      descriptionHtml: map['descriptionHtml'] as String,
      isProfiled: map['isProfiled'] as bool,
      isOfftop: map['isOfftop'] as bool,
      relatedData:
          map['relatedData'] != null
              ? HubRelatedData.fromMap(map['relatedData'])
              : HubRelatedData.empty,
      statistics:
          map['statistics'] != null
              ? HubStatistics.fromMap(map['statistics'])
              : HubStatistics.empty,
      commonTags: UnmodifiableListView(
        List<String>.from(map['commonTags'] ?? []),
      ),
    );
  }

  static const empty = Hub(alias: '-');
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
