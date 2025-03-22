import '../query_params_model.dart';

class FeedListParams extends QueryParams {
  const FeedListParams({
    super.langArticles = 'ru',
    super.langUI = 'ru',
    super.page = '',
    this.complexity = 'all',
    this.score = 'all',
    this.types = const [],
  });

  final String complexity;
  final String score;
  final List<String> types;

  @override
  String toQueryString() {
    String filterParams = '';

    /// Типы публикаций
    for (int i = 0; types.length > i; i++) {
      filterParams += '&types[$i]=${types[i]}';
    }

    /// Сложность и рейтинг
    filterParams += '&complexity=$complexity&score=$score';

    return 'myFeed=true&fl=$langArticles&hl=$langUI$filterParams&page=$page';
  }

  @override
  List<Object?> get props => [...super.props, complexity, score, types];
}
