part of 'articles_cubit.dart';

enum ArticlesStatus { initial, loading, success, error }

class ArticlesState extends Equatable {
  const ArticlesState({
    this.status = ArticlesStatus.initial,
    this.error = '',
    this.type = ArticlesEnum.all,
    this.sort = SortEnum.rating,
    this.period = DatePeriodEnum.daily,
    this.score = '',
    this.page = 1,
    this.pagesCount = 0,
    this.articles = const [],
  });

  final ArticlesStatus status;
  final String error;
  final ArticlesEnum type;
  final SortEnum sort;
  final DatePeriodEnum period;
  final String score;
  final int page;
  final int pagesCount;
  final List<ArticleModel> articles;

  ArticlesState copyWith({
    ArticlesStatus? status,
    String? error,
    ArticlesEnum? type,
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
      type: type ?? this.type,
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
        type,
        sort,
        period,
        score,
        page,
        pagesCount,
        articles,
      ];
}
