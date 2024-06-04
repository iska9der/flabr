import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'user_base.dart';

class UserMeModel extends UserBase with EquatableMixin {
  const UserMeModel({
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

  factory UserMeModel.fromMap(Map<String, dynamic> map) {
    return UserMeModel(
      id: (map['id'] ?? '') as String,
      alias: (map['alias'] ?? '') as String,
      fullname: (map['fullname'] ?? '') as String,
      avatarUrl: (map['avatarUrl'] ?? '') as String,
      email: (map['email'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserMeModel.fromJson(String source) =>
      UserMeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  static const empty = UserMeModel(id: '0');
  bool get isEmpty => this == empty;

  @override
  List<Object> get props => [id, alias, fullname, avatarUrl, email];
}
