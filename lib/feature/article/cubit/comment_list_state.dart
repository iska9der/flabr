part of 'comment_list_cubit.dart';

enum CommentListStatus { initial, loading, success, failure }

class CommentListState extends Equatable {
  const CommentListState({
    this.status = CommentListStatus.initial,
    this.error = '',
    required this.articleId,
    required this.source,
    this.list = CommentListResponse.empty,
  });

  final CommentListStatus status;
  final String error;

  final String articleId;
  final ArticleSource source;
  final CommentListResponse list;

  CommentListState copyWith({
    CommentListStatus? status,
    String? error,
    LanguageEnum? langUI,
    List<LanguageEnum>? langArticles,
    CommentListResponse? list,
  }) {
    return CommentListState(
      status: status ?? this.status,
      error: error ?? this.error,
      articleId: articleId,
      source: source,
      list: list ?? this.list,
    );
  }

  @override
  List<Object> get props => [
        status,
        error,
        articleId,
        source,
        list,
      ];
}
