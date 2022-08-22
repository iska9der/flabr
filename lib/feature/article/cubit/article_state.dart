part of 'article_cubit.dart';

enum ArticleStatus { initial, loading, success, failure }

class ArticleState extends Equatable {
  const ArticleState({
    this.status = ArticleStatus.initial,
    this.error = '',
    required this.id,
    required this.article,
  });

  final ArticleStatus status;
  final String error;
  final String id;
  final ArticleModel article;

  ArticleState copyWith({
    ArticleStatus? status,
    String? error,
    String? id,
    ArticleModel? article,
  }) {
    return ArticleState(
      status: status ?? this.status,
      error: error ?? this.error,
      id: id ?? this.id,
      article: article ?? this.article,
    );
  }

  @override
  List<Object> get props => [status, error, id, article];
}
