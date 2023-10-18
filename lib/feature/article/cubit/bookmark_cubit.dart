import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/exception/exception_helper.dart';
import '../repository/article_repository.dart';

part 'bookmark_state.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  BookmarkCubit({
    required ArticleRepository service,
    required String articleId,
    bool isBookmarked = false,
    int count = 0,
  })  : _service = service,
        super(BookmarkState(
          articleId: articleId,
          isBookmarked: isBookmarked,
          count: count,
        ));

  final ArticleRepository _service;

  toggle() async {
    emit(state.copyWith(status: BookmarkStatus.loading));

    try {
      switch (state.isBookmarked) {
        case false:
          await _addToBookmars();
        case true:
          await _removeFromBookmars();
      }
    } catch (e) {
      emit(state.copyWith(
        status: BookmarkStatus.failure,
        error: ExceptionHelper.parseMessage(e),
      ));
    }
  }

  Future<void> _addToBookmars() async {
    await _service.addToBookmark(state.articleId);

    emit(state.copyWith(
      status: BookmarkStatus.success,
      isBookmarked: true,
      count: state.count + 1,
    ));
  }

  Future<void> _removeFromBookmars() async {
    await _service.removeFromBookmark(state.articleId);

    emit(state.copyWith(
      status: BookmarkStatus.success,
      isBookmarked: false,
      count: state.count - 1,
    ));
  }
}
