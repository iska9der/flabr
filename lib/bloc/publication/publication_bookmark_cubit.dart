import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/exception/exception.dart';
import '../../data/model/publication/publication.dart';
import '../../data/repository/repository.dart';

part 'publication_bookmark_state.dart';

class PublicationBookmarkCubit extends Cubit<PublicationBookmarkState> {
  PublicationBookmarkCubit({
    required PublicationRepository repository,
    required String publicationId,
    required PublicationSource source,
    bool isBookmarked = false,
    int count = 0,
  }) : _repository = repository,
       super(
         PublicationBookmarkState(
           id: publicationId,
           source: source,
           isBookmarked: isBookmarked,
           count: count,
         ),
       );

  final PublicationRepository _repository;

  Future<void> toggle() async {
    emit(state.copyWith(status: BookmarkStatus.loading));

    try {
      switch (state.isBookmarked) {
        case false:
          await _addToBookmars();
        case true:
          await _removeFromBookmars();
      }
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: BookmarkStatus.failure,
          error: error.parseException(),
        ),
      );

      super.onError(error, stackTrace);
    }
  }

  Future<void> _addToBookmars() async {
    await _repository.addToBookmark(id: state.id, source: state.source);

    emit(
      state.copyWith(
        status: BookmarkStatus.success,
        isBookmarked: true,
        count: state.count + 1,
      ),
    );
  }

  Future<void> _removeFromBookmars() async {
    await _repository.removeFromBookmark(id: state.id, source: state.source);

    emit(
      state.copyWith(
        status: BookmarkStatus.success,
        isBookmarked: false,
        count: state.count - 1,
      ),
    );
  }
}
