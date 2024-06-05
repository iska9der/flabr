enum FilterFeedPublication {
  articles(label: 'Статьи'),
  posts(label: 'Посты'),
  news(label: 'Новости'),
  ;

  const FilterFeedPublication({required this.label});

  final String label;
}
