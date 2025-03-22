import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../related_data_base.dart';

class UserRelatedData extends RelatedDataBase with EquatableMixin {
  const UserRelatedData({this.isSubscribed = false});

  final bool isSubscribed;

  static const empty = UserRelatedData();
  bool get isEmpty => this == empty;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'isSubscribed': isSubscribed};
  }

  factory UserRelatedData.fromMap(Map<String, dynamic> map) {
    return UserRelatedData(
      isSubscribed: (map['isSubscribed'] ?? false) as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserRelatedData.fromJson(String source) =>
      UserRelatedData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object> get props => [isSubscribed];
}
