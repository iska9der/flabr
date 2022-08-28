part of 'articles_cubit.dart';

enum ArticlesStatus { initial, loading, success, failure }

class ArticlesState extends Equatable {
  const ArticlesState({
    this.status = ArticlesStatus.initial,
    this.error = '',
    this.type = ArticleType.article,
    this.langUI = LanguageEnum.ru,
    this.langArticles = const [LanguageEnum.ru],
    this.flow = FlowEnum.all,
    this.sort = SortEnum.byNew,
    this.period = DatePeriodEnum.daily,
    this.score = '',
    this.page = 1,
    this.pagesCount = 0,
    this.articles = const [],
  });

  final ArticlesStatus status;
  final String error;
  final ArticleType type;
  final LanguageEnum langUI;
  final List<LanguageEnum> langArticles;
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
    ArticleType? type,
    LanguageEnum? langUI,
    List<LanguageEnum>? langArticles,
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
      type: type ?? this.type,
      langUI: langUI ?? this.langUI,
      langArticles: langArticles ?? this.langArticles,
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
        type,
        langUI,
        langArticles,
        flow,
        sort,
        period,
        score,
        page,
        pagesCount,
        articles,
      ];
}
