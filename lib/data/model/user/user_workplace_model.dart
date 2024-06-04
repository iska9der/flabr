// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserWorkplaceModel extends Equatable {
  const UserWorkplaceModel({
    required this.title,
    required this.alias,
  });

  final String title;
  final String alias;

  UserWorkplaceModel copyWith({
    String? title,
    String? alias,
  }) {
    return UserWorkplaceModel(
      title: title ?? this.title,
      alias: alias ?? this.alias,
    );
  }

  factory UserWorkplaceModel.fromMap(Map<String, dynamic> map) {
    return UserWorkplaceModel(
      title: map['title'] as String,
      alias: map['alias'] as String,
    );
  }

  factory UserWorkplaceModel.fromJson(String source) =>
      UserWorkplaceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  static const UserWorkplaceModel empty =
      UserWorkplaceModel(title: '', alias: '');
  bool get isEmpty => this == empty;

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [title, alias];
}
