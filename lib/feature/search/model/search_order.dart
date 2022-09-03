enum SearchOrder { relevance, date, rating }

extension SearchOrderX on SearchOrder {
  String get label {
    switch (this) {
      case SearchOrder.relevance:
        return 'По релевантности';
      case SearchOrder.date:
        return 'По времени';
      case SearchOrder.rating:
        return 'По рейтингу';
    }
  }
}
