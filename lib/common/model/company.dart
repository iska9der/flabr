import 'related_data.dart';

abstract class CompanyBase {
  const CompanyBase({
    required this.alias,
    this.titleHtml = '',
    this.imageUrl = '',
    this.descriptionHtml = '',
    required this.relatedData,
    this.statistics = const {},
  });

  final String alias;
  final String titleHtml;
  final String imageUrl;
  final String descriptionHtml;
  final RelatedDataBase relatedData;
  final Object statistics;

  CompanyBase copyWith() {
    throw UnimplementedError();
  }

  factory CompanyBase.fromMap(Map<String, dynamic> map) {
    throw UnimplementedError();
  }
}
