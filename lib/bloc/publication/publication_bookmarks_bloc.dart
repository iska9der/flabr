import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/exception/exception.dart';
import '../../data/model/publication/publication.dart';
import '../../data/repository/repository.dart';

part 'publication_bookmarks_bloc.freezed.dart';
part 'publication_bookmarks_event.dart';
part 'publication_bookmarks_state.dart';

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
    final isCurrentlyBookmarked = state.bookmarks[event.publicationId];
    if (isCurrentlyBookmarked == null) {
      return;
    }

    final id = event.publicationId;
    final newValue = !isCurrentlyBookmarked;

    if (state.loadingIds.contains(id)) {
      return;
    }

    emit(
      state.copyWith(
        loadingIds: {...state.loadingIds}..add(id),
        error: null,
      ),
    );

    try {
      switch (newValue) {
        case true:
          await _repository.addToBookmark(
            id: id,
            source: event.source,
          );
        case false:
          await _repository.removeFromBookmark(
            id: id,
            source: event.source,
          );
      }

      final newBookmarks = Map<String, bool>.from(state.bookmarks);
      newBookmarks[id] = newValue;
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
