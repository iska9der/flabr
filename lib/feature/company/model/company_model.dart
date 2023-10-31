// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../../common/model/company.dart';
import 'company_hub_model.dart';
import 'company_related_data.dart';
import 'company_statistics_model.dart';

class CompanyModel extends CompanyBase with EquatableMixin {
  const CompanyModel({
    required super.alias,
    super.imageUrl = '',
    super.titleHtml = '',
    super.descriptionHtml = '',
    super.relatedData = CompanyRelatedData.empty,
    super.statistics = CompanyStatisticsModel.empty,
    this.commonHubs = const [],
  });

  final List<CompanyHubModel> commonHubs;

  @override
  CompanyModel copyWith({
    String? alias,
    String? imageUrl,
    String? titleHtml,
    String? descriptionHtml,
    CompanyRelatedData? relatedData,
    CompanyStatisticsModel? statistics,
    List<CompanyHubModel>? commonHubs,
  }) {
    return CompanyModel(
      alias: alias ?? this.alias,
      imageUrl: imageUrl ?? this.imageUrl,
      titleHtml: titleHtml ?? this.titleHtml,
      descriptionHtml: descriptionHtml ?? this.descriptionHtml,
      relatedData: relatedData ?? this.relatedData,
      statistics: statistics ?? this.statistics,
      commonHubs: commonHubs ?? this.commonHubs,
    );
  }

  factory CompanyModel.fromMap(Map<String, dynamic> map) {
    return CompanyModel(
      alias: (map['alias'] ?? '') as String,
      imageUrl: (map['imageUrl'] ?? '') as String,
      titleHtml: (map['titleHtml'] ?? '') as String,
      descriptionHtml: (map['descriptionHtml'] ?? '') as String,
      relatedData: map['relatedData'] != null
          ? CompanyRelatedData.fromMap(
              map['relatedData'] as Map<String, dynamic>,
            )
          : CompanyRelatedData.empty,
      statistics: map['statistics'] != null
          ? CompanyStatisticsModel.fromMap(
              map['statistics'] as Map<String, dynamic>,
            )
          : CompanyStatisticsModel.empty,
      commonHubs: map['commonHubs'] != null
          ? List<CompanyHubModel>.from(
              map['commonHubs'].map((el) => CompanyHubModel.fromMap(el)),
            ).toList()
          : const [],
    );
  }

  static const empty = CompanyModel(alias: '-');
  bool get isEmpty => this == empty;

  @override
  List<Object> get props => [
        alias,
        imageUrl,
        titleHtml,
        descriptionHtml,
        relatedData,
        statistics,
        commonHubs,
      ];
}
