import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/exception/exception_helper.dart';
import '../../publication/repository/publication_repository.dart';

part 'bookmark_state.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  BookmarkCubit({
    required PublicationRepository repository,
    required String articleId,
    bool isBookmarked = false,
    int count = 0,
  })  : _repository = repository,
        super(BookmarkState(
          articleId: articleId,
          isBookmarked: isBookmarked,
          count: count,
        ));

  final PublicationRepository _repository;

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
    await _repository.addToBookmark(state.articleId);

    emit(state.copyWith(
      status: BookmarkStatus.success,
      isBookmarked: true,
      count: state.count + 1,
    ));
  }

  Future<void> _removeFromBookmars() async {
    await _repository.removeFromBookmark(state.articleId);

    emit(state.copyWith(
      status: BookmarkStatus.success,
      isBookmarked: false,
      count: state.count - 1,
    ));
  }
}
