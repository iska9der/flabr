import '../../../../common/model/company.dart';
import '../company_related_data.dart';
import 'company_card_statistics_model.dart';
import 'company_contact.dart';
import 'company_information.dart';

class CompanyCardModel extends CompanyBase {
  const CompanyCardModel({
    required super.alias,
    super.imageUrl = '',
    super.titleHtml = '',
    super.descriptionHtml = '',
    super.relatedData = CompanyRelatedData.empty,
    super.statistics = CompanyCardStatisticsModel.empty,
    this.information = CompanyInformation.empty,
    this.contacts = const [],
  });

  final CompanyInformation information;
  final List<CompanyContact> contacts;

  @override
  CompanyCardModel copyWith({
    String? alias,
    String? imageUrl,
    String? titleHtml,
    String? descriptionHtml,
    CompanyRelatedData? relatedData,
    CompanyCardStatisticsModel? statistics,
    CompanyInformation? information,
    List<CompanyContact>? contacts,
  }) {
    return CompanyCardModel(
      alias: alias ?? this.alias,
      imageUrl: imageUrl ?? this.imageUrl,
      titleHtml: titleHtml ?? this.titleHtml,
      descriptionHtml: descriptionHtml ?? this.descriptionHtml,
      relatedData: relatedData ?? this.relatedData,
      statistics: statistics ?? this.statistics,
      information: information ?? this.information,
      contacts: contacts ?? this.contacts,
    );
  }

  factory CompanyCardModel.fromMap(Map<String, dynamic> map) {
    final information = CompanyInformation.fromMap(map);

    return CompanyCardModel(
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
          ? CompanyCardStatisticsModel.fromMap(
              map['statistics'] as Map<String, dynamic>,
            )
          : CompanyCardStatisticsModel.empty,
      information: information,
      contacts: map['contacts'] != null
          ? List<CompanyContact>.from(
              map['contacts'].map((e) => CompanyContact.fromMap(e)),
            ).toList()
          : const [],
    );
  }

  static const empty = CompanyCardModel(alias: '-');
  bool get isEmpty => this == empty;

  List<Object> get props => [
        alias,
        imageUrl,
        titleHtml,
        descriptionHtml,
        relatedData,
        statistics,
        information,
        contacts,
      ];
}
