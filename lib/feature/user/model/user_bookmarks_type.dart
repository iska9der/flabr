enum UserBookmarksType {
  articles,
  posts,
  news,
  comments;

  String get label => switch (this) {
        UserBookmarksType.articles => 'Статьи',
        UserBookmarksType.posts => 'Посты',
        UserBookmarksType.news => 'Новости',
        UserBookmarksType.comments => 'Комментарии',
      };

  factory UserBookmarksType.fromString(String value) {
    return UserBookmarksType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => UserBookmarksType.articles,
    );
  }
}
