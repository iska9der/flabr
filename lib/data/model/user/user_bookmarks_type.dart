import '../../../i18n/i18n.dart';

enum UserBookmarksType {
  articles,
  posts,
  news,
  comments;

  String get label => switch (this) {
    UserBookmarksType.articles => t.shortcut.articles,
    UserBookmarksType.posts => t.shortcut.posts,
    UserBookmarksType.news => t.shortcut.news,
    UserBookmarksType.comments => t.search.targetComments,
  };

  factory UserBookmarksType.fromString(String value) {
    return UserBookmarksType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => UserBookmarksType.articles,
    );
  }
}
