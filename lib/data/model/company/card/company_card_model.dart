import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../company_base.dart';
import '../company_related_data_model.dart';

part 'company_card_information_model.dart';
part 'company_card_statistics_model.dart';
part 'company_contact_model.dart';
part 'company_user_representative_model.dart';

class CompanyCard extends CompanyBase {
  const CompanyCard({
    required super.alias,
    super.imageUrl = '',
    super.titleHtml = '',
    super.descriptionHtml = '',
    super.relatedData = CompanyRelatedData.empty,
    super.statistics = CompanyCardStatistics.empty,
    this.information = CompanyCardInformation.empty,
    this.contacts = const [],
  });

  final CompanyCardInformation information;
  final List<CompanyContact> contacts;

  @override
  CompanyCard copyWith({
    String? alias,
    String? imageUrl,
    String? titleHtml,
    String? descriptionHtml,
    CompanyRelatedData? relatedData,
    CompanyCardStatistics? statistics,
    CompanyCardInformation? information,
    List<CompanyContact>? contacts,
  }) {
    return CompanyCard(
      alias: alias ?? this.alias,
      imageUrl: imageUrl ?? this.imageUrl,
      titleHtml: titleHtml ?? this.titleHtml,
      descriptionHtml: descriptionHtml ?? this.descriptionHtml,
      relatedData: relatedData ?? this.relatedData,
      statistics: statistics ?? this.statistics,
      information: information ?? this.information,
      contacts: UnmodifiableListView(contacts ?? this.contacts),
    );
  }

  factory CompanyCard.fromMap(Map<String, dynamic> map) {
    final information = CompanyCardInformation.fromMap(map);
    final contactsList = List<Map<String, dynamic>>.from(map['contacts'] ?? []);

    return CompanyCard(
      alias: (map['alias'] ?? '') as String,
      imageUrl: (map['imageUrl'] ?? '') as String,
      titleHtml: (map['titleHtml'] ?? '') as String,
      descriptionHtml: (map['descriptionHtml'] ?? '') as String,
      relatedData:
          map['relatedData'] != null
              ? CompanyRelatedData.fromMap(
                map['relatedData'] as Map<String, dynamic>,
              )
              : CompanyRelatedData.empty,
      statistics:
          map['statistics'] != null
              ? CompanyCardStatistics.fromMap(
                map['statistics'] as Map<String, dynamic>,
              )
              : CompanyCardStatistics.empty,
      information: information,
      contacts: UnmodifiableListView(
        contactsList.map((e) => CompanyContact.fromMap(e)),
      ),
    );
  }

  static const empty = CompanyCard(alias: '-');
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
