// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_comment_list_cubit.dart';

class UserCommentListState with EquatableMixin {
  const UserCommentListState({
    this.status = .initial,
    this.error = '',
    this.user = '',
    this.page = 1,
    this.response = const ListResponse<UserComment>(),
  });

  final LoadingStatus status;
  final String error;
  final String user;
  final int page;
  final ListResponse<UserComment> response;

  bool get isFirstFetch => page == 1;
  bool get isLastPage => page >= response.pagesCount;

  UserCommentListState copyWith({
    LoadingStatus? status,
    String? error,
    String? user,
    int? page,
    ListResponse<UserComment>? response,
  }) {
    return UserCommentListState(
      status: status ?? this.status,
      error: error ?? this.error,
      user: user ?? this.user,
      page: page ?? this.page,
      response: response ?? this.response,
    );
  }

  @override
  List<Object> get props => [status, error, user, page, response];
}
