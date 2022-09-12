// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../common/model/user.dart';

class MeModel extends UserBase with EquatableMixin {
  const MeModel({
    required super.id,
    super.alias,
    super.fullname,
    super.avatarUrl,
    this.email = '',
  });

  final String email;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'alias': alias,
      'fullname': fullname,
      'avatarUrl': avatarUrl,
      'email': email,
    };
  }

  factory MeModel.fromMap(Map<String, dynamic> map) {
    return MeModel(
      id: (map['id'] ?? '') as String,
      alias: (map['alias'] ?? '') as String,
      fullname: (map['fullname'] ?? '') as String,
      avatarUrl: (map['avatarUrl'] ?? '') as String,
      email: (map['email'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MeModel.fromJson(String source) =>
      MeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  static const empty = MeModel(id: '0');
  bool get isEmpty => this == empty;

  @override
  List<Object> get props => [id, alias, fullname, avatarUrl, email];
}
