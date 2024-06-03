import 'related_data.dart';

abstract class HubBase {
  const HubBase({
    required this.alias,
    this.titleHtml = '',
    this.imageUrl = '',
    this.descriptionHtml = '',
    this.isProfiled = false,
    this.isOfftop = false,
    required this.relatedData,
    this.statistics = const {},
    this.commonTags = const [],
  });

  final String alias;
  final String titleHtml;
  final String imageUrl;
  final String descriptionHtml;
  final bool isProfiled;
  final bool isOfftop;
  final RelatedDataBase relatedData;
  final Object statistics;
  final List<String> commonTags;

  HubBase copyWith() {
    throw UnimplementedError();
  }

  factory HubBase.fromMap(Map<String, dynamic> map) {
    throw UnimplementedError();
  }
}
