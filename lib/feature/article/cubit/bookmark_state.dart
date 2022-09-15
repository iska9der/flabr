// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'bookmark_cubit.dart';

enum BookmarkStatus { success, loading, failure }

class BookmarkState extends Equatable {
  const BookmarkState({
    this.status = BookmarkStatus.success,
    this.error = '',
    required this.articleId,
    this.isBookmarked = false,
    this.count = 0,
  });

  final BookmarkStatus status;
  final String error;
  final String articleId;
  final bool isBookmarked;
  final int count;

  BookmarkState copyWith({
    BookmarkStatus? status,
    String? error,
    bool? isBookmarked,
    int? count,
  }) {
    return BookmarkState(
      status: status ?? this.status,
      error: error ?? this.error,
      articleId: articleId,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      count: count ?? this.count,
    );
  }

  @override
  List<Object> get props => [
        status,
        error,
        articleId,
        isBookmarked,
        count,
      ];
}
