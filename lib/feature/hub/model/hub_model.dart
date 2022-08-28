import 'package:equatable/equatable.dart';

class HubModel extends Equatable {
  const HubModel({
    required this.alias,
    this.titleHtml = '',
    this.imageUrl = '',
    this.descriptionHtml = '',
    required this.isProfiled,
    this.isOfftop = false,
    this.relatedData = const {},
    this.statistics = const {},
    this.commonTags = const [],
  });

  final String alias;
  final String titleHtml;
  final String imageUrl;
  final String descriptionHtml;
  final bool isProfiled;
  final bool isOfftop;
  final Map relatedData;
  final Map statistics;
  final List<String> commonTags;

  HubModel copyWith({
    String? alias,
    String? titleHtml,
    String? imageUrl,
    String? descriptionHtml,
    bool? isProfiled,
    bool? isOfftop,
    Map? relatedData,
    Map? statistics,
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
      relatedData: map['relatedData'],
      statistics: map['statistics'],
      commonTags: map['commonTags'] ?? const [],
    );
  }

  @override
  bool get stringify => true;

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
