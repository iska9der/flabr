// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_comment_list_cubit.dart';

class UserCommentListState with EquatableMixin {
  const UserCommentListState({
    this.status = .initial,
    this.error = '',
    this.user = '',
    this.page = 1,
    this.pages = 1,
    this.comments = const [],
  });

  final LoadingStatus status;
  final String error;
  final String user;
  final int page;
  final int pages;
  final List<UserComment> comments;

  bool get isFirstFetch => page == 1;
  bool get isLastPage => page >= pages;

  UserCommentListState copyWith({
    LoadingStatus? status,
    String? error,
    String? user,
    int? page,
    int? pages,
    List<UserComment>? comments,
  }) {
    return UserCommentListState(
      status: status ?? this.status,
      error: error ?? this.error,
      user: user ?? this.user,
      page: page ?? this.page,
      pages: pages ?? this.pages,
      comments: comments ?? this.comments,
    );
  }

  @override
  List<Object> get props => [status, error, user, page, pages, comments];
}
