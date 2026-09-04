part of 'user_list_cubit.dart';

class UserListState with Equatable {
  const UserListState({
    this.status = LoadingStatus.initial,
    this.error = '',
    this.page = 1,
    this.pagesCount = 0,
    this.users = const [],
  });

  final LoadingStatus status;
  final Object error;
  final int page;
  final int pagesCount;
  final List<User> users;
  int get currentPage => status == .success && page > 1 ? page - 1 : page;
  bool get isLastPage => pagesCount > 0 && currentPage >= pagesCount;

  UserListState copyWith({
    LoadingStatus? status,
    Object? error,
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
