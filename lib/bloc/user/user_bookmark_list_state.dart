part of 'user_bookmark_list_cubit.dart';

class UserBookmarkListState extends PublicationListState with EquatableMixin {
  const UserBookmarkListState({
    super.status = .initial,
    super.error = '',
    super.page = 1,
    super.response = const ListResponse<Publication>(),
    this.user = '',
    this.type = UserBookmarksType.articles,
  });

  final String user;
  final UserBookmarksType type;

  UserBookmarkListState copyWith({
    LoadingStatus? status,
    String? error,
    int? page,
    ListResponse<Publication>? response,
    String? user,
    UserBookmarksType? type,
  }) {
    return UserBookmarkListState(
      status: status ?? this.status,
      error: error ?? this.error,
      page: page ?? this.page,
      response: response ?? this.response,
      user: user ?? this.user,
      type: type ?? this.type,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
    status,
    error,
    page,
    response,
    user,
    type,
  ];
}
