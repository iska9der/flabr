import '../../../i18n/i18n.dart';

enum UserBookmarksType {
  articles,
  posts,
  news,
  comments;

  String get label => switch (this) {
    UserBookmarksType.articles => t.user.bookmarkTypes.articles,
    UserBookmarksType.posts => t.user.bookmarkTypes.posts,
    UserBookmarksType.news => t.user.bookmarkTypes.news,
    UserBookmarksType.comments => t.user.bookmarkTypes.comments,
  };

  factory UserBookmarksType.fromString(String value) {
    return UserBookmarksType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => UserBookmarksType.articles,
    );
  }
}
