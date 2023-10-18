// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserBadgetModel extends Equatable {
  const UserBadgetModel({
    this.title = '',
    this.description = '',
    this.url = '',
    this.isRemovable = false,
  });
  final String title;
  final String description;
  final String url;
  final bool isRemovable;

  UserBadgetModel copyWith({
    String? title,
    String? description,
    String? url,
    bool? isRemovable,
  }) {
    return UserBadgetModel(
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      isRemovable: isRemovable ?? this.isRemovable,
    );
  }

  factory UserBadgetModel.fromMap(Map<String, dynamic> map) {
    return UserBadgetModel(
      title: map['title'],
      description: map['description'],
      url: map['url'] ?? '',
      isRemovable: map['isRemovable'] as bool,
    );
  }

  factory UserBadgetModel.fromJson(String source) =>
      UserBadgetModel.fromMap(json.decode(source) as Map<String, dynamic>);

  static const UserBadgetModel empty = UserBadgetModel();
  bool get isEmpty => this == empty;

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        title,
        description,
        url,
        isRemovable,
      ];
}
