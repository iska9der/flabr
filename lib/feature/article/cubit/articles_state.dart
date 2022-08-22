part of 'articles_cubit.dart';

enum ArticlesStatus { initial, loading, success, failure }

class ArticlesState extends Equatable {
  const ArticlesState({
    this.status = ArticlesStatus.initial,
    this.error = '',
    this.flow = FlowEnum.all,
    this.sort = SortEnum.rating,
    this.period = DatePeriodEnum.daily,
    this.score = '',
    this.page = 1,
    this.pagesCount = 0,
    this.articles = const [],
  });

  final ArticlesStatus status;
  final String error;
  final FlowEnum flow;
  final SortEnum sort;
  final DatePeriodEnum period;
  final String score;
  final int page;
  final int pagesCount;
  final List<ArticleModel> articles;

  ArticlesState copyWith({
    ArticlesStatus? status,
    String? error,
    FlowEnum? flow,
    SortEnum? sort,
    DatePeriodEnum? period,
    String? score,
    int? page,
    int? pagesCount,
    List<ArticleModel>? articles,
  }) {
    return ArticlesState(
      status: status ?? this.status,
      error: error ?? this.error,
      flow: flow ?? this.flow,
      sort: sort ?? this.sort,
      period: period ?? this.period,
      score: score ?? this.score,
      page: page ?? this.page,
      pagesCount: pagesCount ?? this.pagesCount,
      articles: articles ?? this.articles,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        status,
        error,
        flow,
        sort,
        period,
        score,
        page,
        pagesCount,
        articles,
      ];
}
