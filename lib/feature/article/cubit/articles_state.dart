part of 'articles_cubit.dart';

enum ArticlesStatus { initial, loading, success, error }

class ArticlesState extends Equatable {
  const ArticlesState({
    this.status = ArticlesStatus.initial,
    this.error = '',
    this.articles = const [],
  });

  final ArticlesStatus status;
  final String error;
  final List<ArticleModel> articles;

  ArticlesState copyWith({
    ArticlesStatus? status,
    String? error,
    List<ArticleModel>? articles,
  }) {
    return ArticlesState(
      status: status ?? this.status,
      error: error ?? this.error,
      articles: articles ?? this.articles,
    );
  }

  @override
  List<Object> get props => [status, error, articles];
}
