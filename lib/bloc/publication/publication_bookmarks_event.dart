part of 'publication_bookmarks_bloc.dart';

@freezed
sealed class PublicationBookmarksEvent with _$PublicationBookmarksEvent {
  /// Обновить состояние закладок из списка публикаций
  const factory PublicationBookmarksEvent.updated({
    required List<Publication> publications,
  }) = PublicationBookmarksUpdated;

  /// Переключить закладку для публикации
  const factory PublicationBookmarksEvent.toggled({
    required String publicationId,
    required PublicationSource source,
  }) = PublicationBookmarkToggled;
}
