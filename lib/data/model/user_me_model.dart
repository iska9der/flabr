import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'user_base.dart';

class UserMe extends UserBase with EquatableMixin {
  const UserMe({
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

  factory UserMe.fromMap(Map<String, dynamic> map) {
    return UserMe(
      id: (map['id'] ?? '') as String,
      alias: (map['alias'] ?? '') as String,
      fullname: (map['fullname'] ?? '') as String,
      avatarUrl: (map['avatarUrl'] ?? '') as String,
      email: (map['email'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserMe.fromJson(String source) =>
      UserMe.fromMap(json.decode(source) as Map<String, dynamic>);

  static const empty = UserMe(id: '0');
  bool get isEmpty => this == empty;

  @override
  List<Object> get props => [id, alias, fullname, avatarUrl, email];
}
