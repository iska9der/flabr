// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_comment_list_cubit.dart';

enum CommentListStatus { initial, loading, success, failure }

class UserCommentListState extends Equatable {
  const UserCommentListState({
    this.status = CommentListStatus.initial,
    this.error = '',
    this.user = '',
    this.page = 1,
    this.pages = 1,
    this.comments = const [],
  });

  final CommentListStatus status;
  final String error;
  final String user;
  final int page;
  final int pages;
  final List<UserCommentModel> comments;

  bool get isFirstFetch => page == 1;
  bool get isLastPage => page >= pages;

  UserCommentListState copyWith({
    CommentListStatus? status,
    String? error,
    String? user,
    int? page,
    int? pages,
    List<UserCommentModel>? comments,
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
