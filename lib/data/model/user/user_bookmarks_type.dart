import '../../../i18n/i18n.dart';

enum UserBookmarksType {
  articles,
  posts,
  news,
  comments;

  String get label => switch (this) {
    UserBookmarksType.articles => t.user.bookmarks.types.articles,
    UserBookmarksType.posts => t.user.bookmarks.types.posts,
    UserBookmarksType.news => t.user.bookmarks.types.news,
    UserBookmarksType.comments => t.user.bookmarks.types.comments,
  };

  factory UserBookmarksType.fromString(String value) {
    return UserBookmarksType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => UserBookmarksType.articles,
    );
  }
}
