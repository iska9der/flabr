part of 'articles_cubit.dart';

enum ArticlesStatus { initial, loading, success, error }

class ArticlesState extends Equatable {
  const ArticlesState({
    this.status = ArticlesStatus.initial,
    this.error = '',
    this.type = ArticleType.all,
    this.sort = SortEnum.date,
    this.page = '1',
    this.articles = const [],
  });

  final ArticlesStatus status;
  final String error;
  final ArticleType type;
  final SortEnum sort;
  final String page;
  final List<ArticleModel> articles;

  ArticlesState copyWith({
    ArticlesStatus? status,
    String? error,
    ArticleType? type,
    SortEnum? sort,
    String? page,
    List<ArticleModel>? articles,
  }) {
    return ArticlesState(
      status: status ?? this.status,
      error: error ?? this.error,
      type: type ?? this.type,
      sort: sort ?? this.sort,
      page: page ?? this.page,
      articles: articles ?? this.articles,
    );
  }

  @override
  List<Object> get props => [status, error, type, sort, page, articles];
}
