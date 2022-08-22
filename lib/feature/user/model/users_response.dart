import 'package:equatable/equatable.dart';

import 'user_model.dart';

class UsersResponse extends Equatable {
  const UsersResponse({
    required this.pagesCount,
    required this.models,
  });

  final int pagesCount;
  final List<UserModel> models;

  UsersResponse copyWith({
    int? pagesCount,
    List<UserModel>? models,
  }) {
    return UsersResponse(
      pagesCount: pagesCount ?? this.pagesCount,
      models: models ?? this.models,
    );
  }

  factory UsersResponse.fromMap(Map<String, dynamic> map) {
    return UsersResponse(
      pagesCount: map['pagesCount'] ?? 0,
      // models: List<UserModel>.from(
      //   map['data'].map<UserModel>(
      //     (user) => UserModel.fromMap(user as Map<String, dynamic>),
      //   ),
      // ),
      models: Map.from((map['authorRefs'] as Map))
          .entries
          .map((e) => UserModel.fromMap({'alias': e.key, ...e.value}))
          .toList(),
    );
  }

  static const UsersResponse empty = UsersResponse(pagesCount: 0, models: []);
  get isEmpty => this == empty;

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [pagesCount, models];
}
