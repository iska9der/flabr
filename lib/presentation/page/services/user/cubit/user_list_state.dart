part of 'user_list_cubit.dart';

enum UserListStatus { initial, loading, success, failure }

class UserListState extends Equatable {
  const UserListState({
    this.status = UserListStatus.initial,
    this.error = '',
    this.page = 1,
    this.pagesCount = 0,
    this.users = const [],
  });

  final UserListStatus status;
  final String error;
  final int page;
  final int pagesCount;
  final List<UserModel> users;

  UserListState copyWith({
    UserListStatus? status,
    String? error,
    int? page,
    int? pagesCount,
    List<UserModel>? users,
  }) {
    return UserListState(
      status: status ?? this.status,
      error: error ?? this.error,
      page: page ?? this.page,
      pagesCount: pagesCount ?? this.pagesCount,
      users: users ?? this.users,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      status,
      error,
      page,
      pagesCount,
      users,
    ];
  }
}
