import '../../../i18n/i18n.dart';

enum SearchOrder {
  relevance,
  date,
  rating;

  String get label => switch (this) {
    SearchOrder.relevance => t.search.orderRelevance,
    SearchOrder.date => t.search.orderDate,
    SearchOrder.rating => t.search.orderRating,
  };
}
