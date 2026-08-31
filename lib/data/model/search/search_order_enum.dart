import '../../../i18n/i18n.dart';

enum SearchOrder {
  relevance,
  date,
  rating;

  String get label => switch (this) {
    SearchOrder.relevance => t.search.order.relevance,
    SearchOrder.date => t.search.order.date,
    SearchOrder.rating => t.search.order.rating,
  };
}
