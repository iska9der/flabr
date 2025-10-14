part of 'publication_bookmarks_bloc.dart';

typedef Bookmark = ({int count, bool isBookmarked});

@freezed
abstract class PublicationBookmarksState with _$PublicationBookmarksState {
  const factory PublicationBookmarksState({
    @Default({}) Map<String, Bookmark> bookmarks,
    String? error,
    @Default({}) Set<String> loadingIds,
  }) = _PublicationBookmarksState;
}
