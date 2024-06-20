part of 'user_bookmark_list_cubit.dart';

class UserBookmarkListState extends PublicationListState with EquatableMixin {
  const UserBookmarkListState({
    super.status = PublicationListStatus.initial,
    super.error = '',
    super.page = 1,
    super.pagesCount = 0,
    super.publications = const [],
    this.user = '',
    this.type = UserBookmarksType.articles,
    this.comments = const [],
  });

  final String user;
  final UserBookmarksType type;
  final List<Comment> comments;

  UserBookmarkListState copyWith({
    PublicationListStatus? status,
    String? error,
    String? user,
    UserBookmarksType? type,
    int? page,
    int? pagesCount,
    List<Publication>? publications,
    List<Comment>? comments,
  }) {
    return UserBookmarkListState(
      status: status ?? this.status,
      error: error ?? this.error,
      user: user ?? this.user,
      type: type ?? this.type,
      page: page ?? this.page,
      pagesCount: pagesCount ?? this.pagesCount,
      publications: publications ?? this.publications,
      comments: comments ?? this.comments,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        status,
        error,
        user,
        type,
        page,
        pagesCount,
        publications,
        comments,
      ];
}
