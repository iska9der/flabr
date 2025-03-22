import 'package:equatable/equatable.dart';

import '../list_response_model.dart';
import '../user/user_model.dart';

class UserListResponse extends ListResponse<User> with EquatableMixin {
  const UserListResponse({
    super.pagesCount = 1,
    super.ids = const [],
    super.refs = const [],
  });

  factory UserListResponse.fromMap(Map<String, dynamic> map) {
    return UserListResponse(
      pagesCount: map['pagesCount'] ?? 0,
      // models: List<UserModel>.from(
      //   map['data'].map<UserModel>(
      //     (user) => UserModel.fromMap(user as Map<String, dynamic>),
      //   ),
      // ),
      refs:
          Map.from((map['authorRefs'] ?? map['userRefs'] as Map)).entries
              .map((e) => User.fromMap({'alias': e.key, ...e.value}))
              .toList(),
    );
  }

  static const UserListResponse empty = UserListResponse(pagesCount: 0);
  get isEmpty => this == empty;

  @override
  List<Object> get props => [pagesCount, ids, refs];
}
