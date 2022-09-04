part of 'comment_list_cubit.dart';

enum CommentListStatus { initial, loading, success, failure }

class CommentListState extends Equatable {
  const CommentListState({
    this.status = CommentListStatus.initial,
    this.error = '',
    this.langUI = LanguageEnum.ru,
    this.langArticles = const [LanguageEnum.ru],
    required this.articleId,
    this.list = CommentListResponse.empty,
  });

  final CommentListStatus status;
  final String error;
  final LanguageEnum langUI;
  final List<LanguageEnum> langArticles;

  final String articleId;
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
      langUI: langUI ?? this.langUI,
      langArticles: langArticles ?? this.langArticles,
      list: list ?? this.list,
    );
  }

  @override
  List<Object> get props => [
        status,
        error,
        langUI,
        langArticles,
        articleId,
        list,
      ];
}
