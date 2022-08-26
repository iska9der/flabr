part of 'users_cubit.dart';

enum UsersStatus { initial, loading, success, failure }

class UsersState extends Equatable {
  const UsersState({
    this.status = UsersStatus.initial,
    this.error = '',
    this.langUI = LanguageEnum.ru,
    this.langArticles = const [LanguageEnum.ru],
    this.page = 1,
    this.pagesCount = 0,
    this.users = const [],
  });

  final UsersStatus status;
  final String error;
  final LanguageEnum langUI;
  final List<LanguageEnum> langArticles;
  final int page;
  final int pagesCount;
  final List<UserModel> users;

  UsersState copyWith({
    UsersStatus? status,
    String? error,
    LanguageEnum? langUI,
    List<LanguageEnum>? langArticles,
    int? page,
    int? pagesCount,
    List<UserModel>? users,
  }) {
    return UsersState(
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
