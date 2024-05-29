enum FeedPublicationType {
  articles(label: 'Статьи'),
  posts(label: 'Посты'),
  news(label: 'Новости'),
  ;

  const FeedPublicationType({required this.label});

  final String label;
}
