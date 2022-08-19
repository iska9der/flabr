part of 'articles_cubit.dart';

enum ArticlesStatus { initial, loading, success, error }

class ArticlesState extends Equatable {
  const ArticlesState({
    this.status = ArticlesStatus.initial,
    this.error = '',
    this.type = ArticleType.all,
    this.sort = SortEnum.rating,
    this.period = DatePeriodEnum.daily,
    this.score = '',
    this.page = '1',
    this.articles = const [],
  });

  final ArticlesStatus status;
  final String error;
  final ArticleType type;
  final SortEnum sort;
  final DatePeriodEnum period;
  final String score;
  final String page;
  final List<ArticleModel> articles;

  ArticlesState copyWith({
    ArticlesStatus? status,
    String? error,
    ArticleType? type,
    SortEnum? sort,
    DatePeriodEnum? period,
    String? score,
    String? page,
    List<ArticleModel>? articles,
  }) {
    return ArticlesState(
      status: status ?? this.status,
      error: error ?? this.error,
      type: type ?? this.type,
      sort: sort ?? this.sort,
      period: period ?? this.period,
      score: score ?? this.score,
      page: page ?? this.page,
      articles: articles ?? this.articles,
    );
  }

  @override
  List<Object> get props => [
        status,
        error,
        type,
        sort,
        period,
        score,
        page,
        articles,
      ];
}
