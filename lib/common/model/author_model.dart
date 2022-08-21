import 'dart:convert';
import 'package:equatable/equatable.dart';

class AuthorModel extends Equatable {
  const AuthorModel({
    required this.id,
    this.alias = '',
    this.fullname = '',
    this.avatarUrl = '',
    this.speciality = '',
  });

  final String id;
  final String alias;
  final String fullname;
  final String avatarUrl;
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

  factory AuthorModel.fromMap(Map<String, dynamic> map) {
    return AuthorModel(
      id: map['id'],
      alias: map['alias'],
      fullname: map['fullname'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
      speciality: map['speciality'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthorModel.fromJson(String source) =>
      AuthorModel.fromMap(json.decode(source) as Map<String, dynamic>);

  static const empty = AuthorModel(id: '0');
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
