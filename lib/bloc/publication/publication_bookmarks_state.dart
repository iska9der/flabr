part of 'publication_bookmarks_bloc.dart';

@freezed
abstract class PublicationBookmarksState with _$PublicationBookmarksState {
  const factory PublicationBookmarksState({
    @Default({}) Map<String, bool> bookmarks,
    String? error,
    @Default({}) Set<String> loadingIds,
  }) = _PublicationBookmarksState;
}
