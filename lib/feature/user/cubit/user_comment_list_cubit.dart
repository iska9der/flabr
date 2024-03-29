import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/user_comment_model.dart';
import '../repository/user_repository.dart';

part 'user_comment_list_state.dart';

class UserCommentListCubit extends Cubit<UserCommentListState> {
  UserCommentListCubit({
    required UserRepository repository,
    required String user,
  })  : _repository = repository,
        super(UserCommentListState(user: user));

  final UserRepository _repository;

  bool get isFirstFetch => state.page == 1;
  bool get isLastPage => state.page >= state.pages;

  Future<void> fetch() async {
    if (state.status == CommentListStatus.loading ||
        !isFirstFetch && isLastPage) {
      return;
    }

    emit(state.copyWith(status: CommentListStatus.loading));

    try {
      final response = await _repository.fetchComments(
        alias: state.user,
        page: state.page,
      );

      emit(state.copyWith(
        status: CommentListStatus.success,
        comments: [...state.comments, ...response.refs],
        page: state.page + 1,
        pages: response.pagesCount,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CommentListStatus.failure,
        error: e.toString(),
      ));
    }
  }

  Future<void> fetchBookmarks() async {
    if (state.status == CommentListStatus.loading ||
        !isFirstFetch && isLastPage) {
      return;
    }

    emit(state.copyWith(status: CommentListStatus.loading));

    try {
      final response = await _repository.fetchCommentsInBookmarks(
        alias: state.user,
        page: state.page,
      );

      emit(state.copyWith(
        status: CommentListStatus.success,
        comments: [...state.comments, ...response.refs],
        page: state.page + 1,
        pages: response.pagesCount,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CommentListStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
