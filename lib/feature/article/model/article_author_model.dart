import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../common/model/user.dart';

class ArticleAuthorModel extends UserBase with EquatableMixin {
  const ArticleAuthorModel({
    required super.id,
    super.alias = '',
    super.fullname = '',
    super.avatarUrl = '',
    this.speciality = '',
  });

  final String speciality;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'alias': alias,
      'fullname': fullname,
      'avatarUrl': avatarUrl,
      'speciality': speciality,
    };
  }

  factory ArticleAuthorModel.fromMap(Map<String, dynamic> map) {
    return ArticleAuthorModel(
      id: map['id'],
      alias: map['alias'],
      fullname: map['fullname'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
      speciality: map['speciality'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ArticleAuthorModel.fromJson(String source) =>
      ArticleAuthorModel.fromMap(json.decode(source) as Map<String, dynamic>);

  static const empty = ArticleAuthorModel(id: '0');
  bool get isEmpty => this == empty;

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        id,
        alias,
        fullname,
        avatarUrl,
        speciality,
      ];
}
