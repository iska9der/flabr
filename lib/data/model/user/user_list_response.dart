import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../list_response_model.dart';
import 'user_model.dart';

class UserListResponse extends ListResponse<User> with EquatableMixin {
  const UserListResponse({
    super.pagesCount = 1,
    super.ids = const [],
    super.refs = const [],
  });

  factory UserListResponse.fromMap(Map<String, dynamic> map) {
    final idsMap = List<String>.from(map['authorIds'] ?? map['userIds'] ?? []);
    final refsMap = Map<String, dynamic>.from(
      map['authorRefs'] ?? map['userRefs'] ?? {},
    );

    return UserListResponse(
      pagesCount: map['pagesCount'] ?? 0,
      // models: UnmodifiableListView(
      //   map['data'].map<UserModel>(
      //     (user) => UserModel.fromMap(user as Map<String, dynamic>),
      //   ),
      // ),
      ids: UnmodifiableListView(idsMap),
      refs: UnmodifiableListView(
        refsMap.entries.map((e) => User.fromMap({'alias': e.key, ...e.value})),
      ),
    );
  }

  static const UserListResponse empty = UserListResponse(pagesCount: 0);
  bool get isEmpty => this == empty;

  @override
  List<Object> get props => [pagesCount, ids, refs];
}
