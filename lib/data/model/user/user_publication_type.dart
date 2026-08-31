import '../../../i18n/i18n.dart';

enum UserPublicationType {
  articles,
  posts,
  news;

  String get label => switch (this) {
    UserPublicationType.articles => t.user.publications.types.articles,
    UserPublicationType.posts => t.user.publications.types.posts,
    UserPublicationType.news => t.user.publications.types.news,
  };

  factory UserPublicationType.fromString(String value) {
    return UserPublicationType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => UserPublicationType.articles,
    );
  }
}
