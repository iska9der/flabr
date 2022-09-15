import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/exception/displayable_exception.dart';
import '../service/article_service.dart';

part 'bookmark_state.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  BookmarkCubit({
    required ArticleService service,
    required String articleId,
    bool isBookmarked = false,
    int count = 0,
  })  : _service = service,
        super(BookmarkState(
          articleId: articleId,
          isBookmarked: isBookmarked,
          count: count,
        ));

  final ArticleService _service;

  toggle() async {
    emit(state.copyWith(status: BookmarkStatus.loading));

    try {
      switch (state.isBookmarked) {
        case false:
          await _add();
          break;
        case true:
          await _remove();
          break;
      }
    } on DisplayableException catch (e) {
      emit(state.copyWith(
        status: BookmarkStatus.failure,
        error: e.toString(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BookmarkStatus.failure,
        error: 'Не удалось',
      ));
    }
  }

  Future<void> _add() async {
    await _service.addToBookmark(state.articleId);

    emit(state.copyWith(
      status: BookmarkStatus.success,
      isBookmarked: true,
      count: state.count + 1,
    ));
  }

  Future<void> _remove() async {
    await _service.removeFromBookmark(state.articleId);

    emit(state.copyWith(
      status: BookmarkStatus.success,
      isBookmarked: false,
      count: state.count - 1,
    ));
  }
}
