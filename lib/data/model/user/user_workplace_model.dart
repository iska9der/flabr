// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserWorkplace with EquatableMixin {
  const UserWorkplace({
    required this.title,
    required this.alias,
  });

  final String title;
  final String alias;

  UserWorkplace copyWith({
    String? title,
    String? alias,
  }) {
    return UserWorkplace(
      title: title ?? this.title,
      alias: alias ?? this.alias,
    );
  }

  factory UserWorkplace.fromMap(Map<String, dynamic> map) {
    return UserWorkplace(
      title: map['title'] as String,
      alias: map['alias'] as String,
    );
  }

  factory UserWorkplace.fromJson(String source) =>
      UserWorkplace.fromMap(json.decode(source) as Map<String, dynamic>);

  static const UserWorkplace empty = UserWorkplace(title: '', alias: '');
  bool get isEmpty => this == empty;

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [title, alias];
}
