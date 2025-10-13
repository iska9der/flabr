part of 'publication_bookmarks_bloc.dart';

enum BookmarkOperationStatus { idle, loading, success, failure }

@freezed
abstract class PublicationBookmarksState with _$PublicationBookmarksState {
  const factory PublicationBookmarksState({
    @Default({}) Map<String, bool> bookmarks,
    @Default(BookmarkOperationStatus.idle) BookmarkOperationStatus status,
    @Default('') String error,
    String? operatingPublicationId,
  }) = _PublicationBookmarksState;
}
