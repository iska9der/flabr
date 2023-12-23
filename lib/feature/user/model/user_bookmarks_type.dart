enum UserBookmarksType {
  articles,
  posts,
  news;

  /// TODO: реализовать получение комментов в закладках
  /// comments;

  String get label => switch (this) {
        UserBookmarksType.articles => 'Статьи',
        UserBookmarksType.posts => 'Посты',
        UserBookmarksType.news => 'Новости',
      };

  factory UserBookmarksType.fromString(String value) {
    return UserBookmarksType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => UserBookmarksType.articles,
    );
  }
}
