import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../user_base.dart';

class PublicationAuthor extends UserBase with EquatableMixin {
  const PublicationAuthor({
    required super.id,
    super.alias = '',
    super.fullname = '',
    super.avatarUrl = '',
    this.speciality = '',
  });

  final String speciality;

  factory PublicationAuthor.fromMap(Map<String, dynamic> map) {
    return PublicationAuthor(
      id: map['id'],
      alias: map['alias'],
      fullname: map['fullname'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
      speciality: map['speciality'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'speciality': speciality,
      'alias': alias,
      'fullname': fullname,
      'avatarUrl': avatarUrl,
    };
  }

  String toJson() => json.encode(toMap());

  static const empty = PublicationAuthor(id: '0');
  bool get isEmpty => this == empty;

  @override
  List<Object> get props => [
        id,
        alias,
        fullname,
        avatarUrl,
        speciality,
      ];
}
