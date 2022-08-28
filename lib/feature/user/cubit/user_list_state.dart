part of 'user_list_cubit.dart';

enum UserListStatus { initial, loading, success, failure }

class UserListState extends Equatable {
  const UserListState({
    this.status = UserListStatus.initial,
    this.error = '',
    this.langUI = LanguageEnum.ru,
    this.langArticles = const [LanguageEnum.ru],
    this.page = 1,
    this.pagesCount = 0,
    this.users = const [],
  });

  final UserListStatus status;
  final String error;
  final LanguageEnum langUI;
  final List<LanguageEnum> langArticles;
  final int page;
  final int pagesCount;
  final List<UserModel> users;

  UserListState copyWith({
    UserListStatus? status,
    String? error,
    LanguageEnum? langUI,
    List<LanguageEnum>? langArticles,
    int? page,
    int? pagesCount,
    List<UserModel>? users,
  }) {
    return UserListState(
      status: status ?? this.status,
      error: error ?? this.error,
      langUI: langUI ?? this.langUI,
      langArticles: langArticles ?? this.langArticles,
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
      langUI,
      langArticles,
      page,
      pagesCount,
      users,
    ];
  }
}
