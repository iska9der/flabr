import '../../../i18n/i18n.dart';

enum UserPublicationType {
  articles,
  posts,
  news;

  String get label => switch (this) {
    UserPublicationType.articles => t.user.publicationTypes.articles,
    UserPublicationType.posts => t.user.publicationTypes.posts,
    UserPublicationType.news => t.user.publicationTypes.news,
  };

  factory UserPublicationType.fromString(String value) {
    return UserPublicationType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => UserPublicationType.articles,
    );
  }
}
