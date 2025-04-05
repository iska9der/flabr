// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'publication_bookmark_cubit.dart';

enum BookmarkStatus { success, loading, failure }

class PublicationBookmarkState extends Equatable {
  const PublicationBookmarkState({
    this.status = BookmarkStatus.success,
    this.error = '',
    required this.id,
    required this.source,
    this.isBookmarked = false,
    this.count = 0,
  });

  final BookmarkStatus status;
  final String error;
  final String id;
  final PublicationSource source;
  final bool isBookmarked;
  final int count;

  PublicationBookmarkState copyWith({
    BookmarkStatus? status,
    String? error,
    bool? isBookmarked,
    int? count,
  }) {
    return PublicationBookmarkState(
      status: status ?? this.status,
      error: error ?? this.error,
      id: id,
      source: source,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      count: count ?? this.count,
    );
  }

  @override
  List<Object> get props => [status, error, id, source, isBookmarked, count];
}
