part of 'user_list_cubit.dart';

class UserListState with EquatableMixin {
  const UserListState({
    this.status = LoadingStatus.initial,
    this.error = '',
    this.page = 1,
    this.pagesCount = 0,
    this.users = const [],
  });

  final LoadingStatus status;
  final String error;
  final int page;
  final int pagesCount;
  final List<User> users;

  UserListState copyWith({
    LoadingStatus? status,
    String? error,
    int? page,
    int? pagesCount,
    List<User>? users,
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
