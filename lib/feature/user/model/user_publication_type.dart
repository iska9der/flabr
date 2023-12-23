enum UserPublicationType {
  articles,
  posts,
  news;

  String get label => switch (this) {
        UserPublicationType.articles => 'Статьи',
        UserPublicationType.posts => 'Посты',
        UserPublicationType.news => 'Новости',
      };

  factory UserPublicationType.fromString(String value) {
    return UserPublicationType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => UserPublicationType.articles,
    );
  }
}
