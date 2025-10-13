import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/exception/exception.dart';
import '../../data/model/publication/publication.dart';
import '../../data/repository/repository.dart';

part 'publication_bookmarks_event.dart';
part 'publication_bookmarks_state.dart';
part 'publication_bookmarks_bloc.freezed.dart';

class PublicationBookmarksBloc
    extends Bloc<PublicationBookmarksEvent, PublicationBookmarksState> {
  PublicationBookmarksBloc({
    required PublicationRepository repository,
  })  : _repository = repository,
        super(const PublicationBookmarksState()) {
    on<PublicationBookmarksUpdated>(_onUpdated);
    on<PublicationBookmarkToggled>(_onToggled);
  }

  final PublicationRepository _repository;

  void _onUpdated(
    PublicationBookmarksUpdated event,
    Emitter<PublicationBookmarksState> emit,
  ) {
    final newBookmarks = Map<String, bool>.from(state.bookmarks);

    for (final publication in event.publications) {
      newBookmarks[publication.id] = publication.relatedData.bookmarked;
    }

    emit(state.copyWith(bookmarks: newBookmarks));
  }

  Future<void> _onToggled(
    PublicationBookmarkToggled event,
    Emitter<PublicationBookmarksState> emit,
  ) async {
    final isCurrentlyBookmarked = state.bookmarks[event.publicationId] ?? false;
    final newValue = !isCurrentlyBookmarked;

    // Оптимистичное обновление UI
    final newBookmarks = Map<String, bool>.from(state.bookmarks);
    newBookmarks[event.publicationId] = newValue;
    emit(state.copyWith(
      bookmarks: newBookmarks,
      status: BookmarkOperationStatus.loading,
      operatingPublicationId: event.publicationId,
    ));

    try {
      if (newValue) {
        await _repository.addToBookmark(
          id: event.publicationId,
          source: event.source,
        );
      } else {
        await _repository.removeFromBookmark(
          id: event.publicationId,
          source: event.source,
        );
      }

      emit(state.copyWith(
        status: BookmarkOperationStatus.success,
        operatingPublicationId: null,
      ));
    } catch (error, stackTrace) {
      // Откатываем изменения при ошибке
      final revertedBookmarks = Map<String, bool>.from(state.bookmarks);
      revertedBookmarks[event.publicationId] = isCurrentlyBookmarked;

      emit(state.copyWith(
        bookmarks: revertedBookmarks,
        status: BookmarkOperationStatus.failure,
        error: error.parseException(),
        operatingPublicationId: null,
      ));

      addError(error, stackTrace);
    }
  }
}
