part of 'article_list_cubit.dart';

enum ArticleListStatus { initial, loading, success, failure }

class ArticleListState extends Equatable {
  const ArticleListState({
    this.status = ArticleListStatus.initial,
    this.error = '',
    this.source = ArticleListSource.flow,
    this.flow = FlowEnum.all,
    this.hub = '',
    this.user = '',
    this.type = PublicationType.article,
    this.sort = SortEnum.byNew,
    this.period = DatePeriodEnum.daily,
    this.score = '',
    this.page = 1,
    this.pagesCount = 0,
    this.articles = const [],
  });

  final ArticleListStatus status;
  final String error;
  final ArticleListSource source;
  final FlowEnum flow;
  final String hub;
  final String user;
  final PublicationType type;
  final SortEnum sort;
  final DatePeriodEnum period;
  final String score;
  final int page;
  final int pagesCount;
  final List<ArticleModel> articles;

  ArticleListState copyWith({
    ArticleListStatus? status,
    String? error,
    ArticleListSource? source,
    FlowEnum? flow,
    String? hub,
    String? user,
    PublicationType? type,
    SortEnum? sort,
    DatePeriodEnum? period,
    String? score,
    int? page,
    int? pagesCount,
    List<ArticleModel>? articles,
  }) {
    return ArticleListState(
      status: status ?? this.status,
      error: error ?? this.error,
      source: source ?? this.source,
      flow: flow ?? this.flow,
      hub: hub ?? this.hub,
      user: user ?? this.user,
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
        source,
        flow,
        hub,
        user,
        type,
        sort,
        period,
        score,
        page,
        pagesCount,
        articles,
      ];
}
