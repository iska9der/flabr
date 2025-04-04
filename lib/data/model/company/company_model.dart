// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../company_base.dart';
import 'company_hub_model.dart';
import 'company_related_data_model.dart';
import 'company_statistics_model.dart';

class Company extends CompanyBase with EquatableMixin {
  const Company({
    required super.alias,
    super.imageUrl = '',
    super.titleHtml = '',
    super.descriptionHtml = '',
    super.relatedData = CompanyRelatedData.empty,
    super.statistics = CompanyStatistics.empty,
    this.commonHubs = const [],
  });

  final List<CompanyHub> commonHubs;

  @override
  Company copyWith({
    String? alias,
    String? imageUrl,
    String? titleHtml,
    String? descriptionHtml,
    CompanyRelatedData? relatedData,
    CompanyStatistics? statistics,
    List<CompanyHub>? commonHubs,
  }) {
    return Company(
      alias: alias ?? this.alias,
      imageUrl: imageUrl ?? this.imageUrl,
      titleHtml: titleHtml ?? this.titleHtml,
      descriptionHtml: descriptionHtml ?? this.descriptionHtml,
      relatedData: relatedData ?? this.relatedData,
      statistics: statistics ?? this.statistics,
      commonHubs: UnmodifiableListView(commonHubs ?? this.commonHubs),
    );
  }

  factory Company.fromMap(Map<String, dynamic> map) {
    final hubsList = List<Map<String, dynamic>>.from(map['commonHubs'] ?? []);

    return Company(
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
              ? CompanyStatistics.fromMap(
                map['statistics'] as Map<String, dynamic>,
              )
              : CompanyStatistics.empty,
      commonHubs: UnmodifiableListView(
        hubsList.map((hub) => CompanyHub.fromMap(hub)),
      ),
    );
  }

  static const empty = Company(alias: '-');
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
