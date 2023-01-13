// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'company_related_data.dart';

class CompanyModel extends Equatable {
  const CompanyModel({
    required this.alias,
    this.imageUrl = '',
    this.titleHtml = '',
    this.descriptionHtml = '',
    this.relatedData = CompanyRelatedData.empty,
  });

  final String alias;
  final String imageUrl;
  final String titleHtml;
  final String descriptionHtml;
  final CompanyRelatedData relatedData;

  CompanyModel copyWith({
    String? alias,
    String? imageUrl,
    String? titleHtml,
    String? descriptionHtml,
    CompanyRelatedData? relatedData,
  }) {
    return CompanyModel(
      alias: alias ?? this.alias,
      imageUrl: imageUrl ?? this.imageUrl,
      titleHtml: titleHtml ?? this.titleHtml,
      descriptionHtml: descriptionHtml ?? this.descriptionHtml,
      relatedData: relatedData ?? this.relatedData,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'alias': alias,
      'imageUrl': imageUrl,
      'titleHtml': titleHtml,
      'descriptionHtml': descriptionHtml,
      'relatedData': relatedData.toMap(),
    };
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
    );
  }

  String toJson() => json.encode(toMap());

  factory CompanyModel.fromJson(String source) =>
      CompanyModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object> get props {
    return [
      alias,
      imageUrl,
      titleHtml,
      descriptionHtml,
      relatedData,
    ];
  }
}
