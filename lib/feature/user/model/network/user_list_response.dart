import 'package:equatable/equatable.dart';

import '../../../../common/model/network/list_response.dart';
import '../user_model.dart';

class UserListResponse extends ListResponse with EquatableMixin {
  const UserListResponse({
    super.pagesCount = 1,
    super.ids = const [],
    super.refs = const [],
  });

  UserListResponse copyWith({
    int? pagesCount,
    List<String>? ids,
    List<UserModel>? refs,
  }) {
    return UserListResponse(
      pagesCount: pagesCount ?? this.pagesCount,
      ids: ids ?? this.ids,
      refs: refs ?? this.refs as List<UserModel>,
    );
  }

  factory UserListResponse.fromMap(Map<String, dynamic> map) {
    return UserListResponse(
      pagesCount: map['pagesCount'] ?? 0,
      // models: List<UserModel>.from(
      //   map['data'].map<UserModel>(
      //     (user) => UserModel.fromMap(user as Map<String, dynamic>),
      //   ),
      // ),
      refs: Map.from((map['authorRefs'] as Map))
          .entries
          .map((e) => UserModel.fromMap({'alias': e.key, ...e.value}))
          .toList(),
    );
  }

  static const UserListResponse empty = UserListResponse(pagesCount: 0);
  get isEmpty => this == empty;

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [pagesCount, ids, refs];
}
