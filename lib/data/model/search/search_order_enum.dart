enum SearchOrder {
  relevance,
  date,
  rating;

  String get label => switch (this) {
        SearchOrder.relevance => 'По релевантности',
        SearchOrder.date => 'По времени',
        SearchOrder.rating => 'По рейтингу'
      };
}
