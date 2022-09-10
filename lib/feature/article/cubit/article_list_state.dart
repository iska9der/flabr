part of 'article_list_cubit.dart';

enum ArticlesStatus { initial, loading, success, failure }

class ArticleListState extends Equatable {
  const ArticleListState({
    this.status = ArticlesStatus.initial,
    this.error = '',
    this.from = ArticleFromEnum.flow,
    this.flow = FlowEnum.all,
    this.connectSid = '',
    this.hub = '',
    this.user = '',
    this.langUI = LanguageEnum.ru,
    this.langArticles = const [LanguageEnum.ru],
    this.type = ArticleType.article,
    this.sort = SortEnum.byNew,
    this.period = DatePeriodEnum.daily,
    this.score = '',
    this.page = 1,
    this.pagesCount = 0,
    this.articles = const [],
  });

  final ArticlesStatus status;
  final String error;
  final ArticleFromEnum from;
  final FlowEnum flow;
  final String connectSid;
  final String hub;
  final String user;
  final LanguageEnum langUI;
  final List<LanguageEnum> langArticles;
  final ArticleType type;
  final SortEnum sort;
  final DatePeriodEnum period;
  final String score;
  final int page;
  final int pagesCount;
  final List<ArticleModel> articles;

  ArticleListState copyWith({
    ArticlesStatus? status,
    String? error,
    ArticleFromEnum? from,
    FlowEnum? flow,
    String? connectSid,
    String? hub,
    String? user,
    LanguageEnum? langUI,
    List<LanguageEnum>? langArticles,
    ArticleType? type,
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
      from: from ?? this.from,
      flow: flow ?? this.flow,
      connectSid: connectSid ?? this.connectSid,
      hub: hub ?? this.hub,
      user: user ?? this.user,
      langUI: langUI ?? this.langUI,
      langArticles: langArticles ?? this.langArticles,
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
        from,
        flow,
        connectSid,
        hub,
        user,
        langUI,
        langArticles,
        type,
        sort,
        period,
        score,
        page,
        pagesCount,
        articles,
      ];
}
