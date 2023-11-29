part of 'article_cubit.dart';

enum ArticleStatus { initial, loading, success, failure }

class ArticleState extends Equatable {
  const ArticleState({
    this.status = ArticleStatus.initial,
    this.error = '',
    required this.id,
    required this.source,
    required this.article,
  });

  final ArticleStatus status;
  final String error;

  final String id;
  final ArticleSource source;
  final ArticleModel article;

  ArticleState copyWith({
    ArticleStatus? status,
    String? error,
    ArticleModel? article,
  }) {
    return ArticleState(
      id: id,
      source: source,
      status: status ?? this.status,
      error: error ?? this.error,
      article: article ?? this.article,
    );
  }

  @override
  List<Object> get props => [
        status,
        error,
        id,
        source,
        article,
      ];
}
