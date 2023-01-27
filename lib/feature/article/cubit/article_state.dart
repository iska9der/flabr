part of 'article_cubit.dart';

enum ArticleStatus { initial, loading, success, failure }

class ArticleState extends Equatable {
  const ArticleState({
    this.status = ArticleStatus.initial,
    this.error = '',
    required this.id,
    required this.article,
    this.langUI = LanguageEnum.ru,
    this.langArticles = const [LanguageEnum.ru],
  });

  final ArticleStatus status;
  final String error;

  final String id;
  final ArticleModel article;

  final LanguageEnum langUI;
  final List<LanguageEnum> langArticles;

  ArticleState copyWith({
    ArticleStatus? status,
    String? error,
    String? id,
    ArticleModel? article,
    LanguageEnum? langUI,
    List<LanguageEnum>? langArticles,
  }) {
    return ArticleState(
      status: status ?? this.status,
      error: error ?? this.error,
      id: id ?? this.id,
      article: article ?? this.article,
      langUI: langUI ?? this.langUI,
      langArticles: langArticles ?? this.langArticles,
    );
  }

  @override
  List<Object> get props => [
        status,
        error,
        id,
        article,
        langUI,
        langArticles,
      ];
}
