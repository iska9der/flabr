// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'most_reading_cubit.dart';

enum ArticleMostReadingStatus { initial, loading, success, failure }

class MostReadingState extends Equatable {
  const MostReadingState({
    this.status = ArticleMostReadingStatus.initial,
    this.error = '',
    this.langUI = LanguageEnum.ru,
    this.langArticles = const [LanguageEnum.ru],
    this.articles = const [],
  });

  final ArticleMostReadingStatus status;
  final String error;
  final LanguageEnum langUI;
  final List<LanguageEnum> langArticles;
  final List<CommonModel> articles;

  MostReadingState copyWith({
    ArticleMostReadingStatus? status,
    String? error,
    LanguageEnum? langUI,
    List<LanguageEnum>? langArticles,
    List<CommonModel>? articles,
  }) {
    return MostReadingState(
      status: status ?? this.status,
      error: error ?? this.error,
      langUI: langUI ?? this.langUI,
      langArticles: langArticles ?? this.langArticles,
      articles: articles ?? this.articles,
    );
  }

  @override
  List<Object> get props => [
        status,
        error,
        langUI,
        langArticles,
        articles,
      ];
}
