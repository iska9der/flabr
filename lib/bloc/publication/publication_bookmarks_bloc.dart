import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/component/logger/logger.dart';
import '../../data/exception/exception.dart';
import '../../data/model/publication/publication.dart';
import '../../data/repository/repository.dart';

part 'publication_bookmarks_bloc.freezed.dart';
part 'publication_bookmarks_event.dart';
part 'publication_bookmarks_state.dart';

/// TODO: Всюду лезть приходится, листенерами оборачивать после загрузки
/// списка публикаций. Можно увидеть, если проследить за вызовом
/// [PublicationBookmarksEvent.updated].
///
/// Можно создать в репозитории `Stream<Map<String, Bookmark> bookmarks>`
/// и слушать его в этом блоке, пробрасывая в стейт.
///
/// Только надо убедиться, что везде используется [PublicationRepository]
class PublicationBookmarksBloc
    extends Bloc<PublicationBookmarksEvent, PublicationBookmarksState> {
  PublicationBookmarksBloc({
    required PublicationRepository repository,
  }) : _repository = repository,
       super(const PublicationBookmarksState()) {
    on<PublicationBookmarksUpdated>(_onUpdated, transformer: sequential());
    on<PublicationBookmarkToggled>(_onToggled, transformer: concurrent());
  }

  final PublicationRepository _repository;

  void _onUpdated(
    PublicationBookmarksUpdated event,
    Emitter<PublicationBookmarksState> emit,
  ) {
    final newBookmarks = Map<String, Bookmark>.from(state.bookmarks);

    for (final publication in event.publications) {
      newBookmarks[publication.id] = (
        count: publication.statistics.favoritesCount,
        isBookmarked: publication.relatedData.bookmarked,
      );
    }

    emit(state.copyWith(bookmarks: newBookmarks));
  }

  Future<void> _onToggled(
    PublicationBookmarkToggled event,
    Emitter<PublicationBookmarksState> emit,
  ) async {
    final bookmark = state.bookmarks[event.publicationId];

    if (bookmark == null) {
      logger.warning(
        'Закладки: не найдена запись в стейте',
        stackTrace: StackTrace.current,
      );

      return;
    }

    final id = event.publicationId;
    if (state.loadingIds.contains(id)) {
      return;
    }

    emit(
      state.copyWith(
        loadingIds: {...state.loadingIds}..add(id),
        error: null,
      ),
    );

    final isNeedToBookmark = !bookmark.isBookmarked;
    int count = bookmark.count;

    try {
      switch (isNeedToBookmark) {
        case true:
          await _repository.addToBookmark(
            id: id,
            source: event.source,
          );
          count++;
        case false:
          await _repository.removeFromBookmark(
            id: id,
            source: event.source,
          );
          count--;
      }

      final newBookmarks = Map<String, Bookmark>.from(state.bookmarks);
      newBookmarks[id] = (count: count, isBookmarked: isNeedToBookmark);
      emit(
        state.copyWith(
          bookmarks: newBookmarks,
          loadingIds: {...state.loadingIds}..remove(id),
        ),
      );
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          error: error.parseException(),
          loadingIds: {...state.loadingIds}..remove(id),
        ),
      );

      addError(error, stackTrace);
    }
  }
}
