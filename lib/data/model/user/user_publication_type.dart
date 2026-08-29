import '../../../i18n/i18n.dart';

enum UserPublicationType {
  articles,
  posts,
  news;

  String get label => switch (this) {
    UserPublicationType.articles => t.shortcut.articles,
    UserPublicationType.posts => t.shortcut.posts,
    UserPublicationType.news => t.shortcut.news,
  };

  factory UserPublicationType.fromString(String value) {
    return UserPublicationType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => UserPublicationType.articles,
    );
  }
}
