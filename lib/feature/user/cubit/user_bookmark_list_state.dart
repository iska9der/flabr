part of 'user_bookmark_list_cubit.dart';

class UserBookmarkListState extends Equatable implements PublicationListState {
  const UserBookmarkListState({
    this.status = PublicationListStatus.initial,
    this.error = '',
    this.user = '',
    this.type = UserBookmarksType.articles,
    this.page = 1,
    this.pagesCount = 0,
    this.publications = const [],
    this.comments = const [],
  });

  @override
  final PublicationListStatus status;
  @override
  final String error;
  final String user;
  final UserBookmarksType type;
  @override
  final int page;
  @override
  final int pagesCount;
  @override
  final List<Publication> publications;
  final List<CommentModel> comments;

  UserBookmarkListState copyWith({
    PublicationListStatus? status,
    String? error,
    String? user,
    UserBookmarksType? type,
    int? page,
    int? pagesCount,
    List<Publication>? publications,
    List<CommentModel>? comments,
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
