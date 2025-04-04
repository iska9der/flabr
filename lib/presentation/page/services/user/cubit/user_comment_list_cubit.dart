import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/exception/exception.dart';
import '../../../../../data/model/user/user.dart';
import '../../../../../data/repository/repository.dart';

part 'user_comment_list_state.dart';

class UserCommentListCubit extends Cubit<UserCommentListState> {
  UserCommentListCubit({
    required UserRepository repository,
    required String user,
  }) : _repository = repository,
       super(UserCommentListState(user: user));

  final UserRepository _repository;

  void refetch() {
    emit(
      state.copyWith(
        status: CommentListStatus.initial,
        page: 1,
        comments: [],
        pages: 0,
      ),
    );
  }

  Future<void> fetch() async {
    if (state.status == CommentListStatus.loading ||
        !state.isFirstFetch && state.isLastPage) {
      return;
    }

    emit(state.copyWith(status: CommentListStatus.loading));

    try {
      final response = await _repository.fetchComments(
        alias: state.user,
        page: state.page,
      );

      emit(
        state.copyWith(
          status: CommentListStatus.success,
          comments: [...state.comments, ...response.refs],
          page: state.page + 1,
          pages: response.pagesCount,
        ),
      );
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: CommentListStatus.failure,
          error: error.parseException('Не удалось получить комментарии'),
        ),
      );

      super.onError(error, stackTrace);
    }
  }

  Future<void> fetchBookmarks() async {
    if (state.status == CommentListStatus.loading ||
        !state.isFirstFetch && state.isLastPage) {
      return;
    }

    emit(state.copyWith(status: CommentListStatus.loading));

    try {
      final response = await _repository.fetchCommentsInBookmarks(
        alias: state.user,
        page: state.page,
      );

      emit(
        state.copyWith(
          status: CommentListStatus.success,
          comments: [...state.comments, ...response.refs],
          page: state.page + 1,
          pages: response.pagesCount,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: CommentListStatus.failure, error: e.toString()),
      );
    }
  }
}
