// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'most_reading_cubit.dart';

enum ArticleMostReadingStatus { initial, loading, success, failure }

class MostReadingState extends Equatable {
  const MostReadingState({
    this.status = ArticleMostReadingStatus.initial,
    this.error = '',
    this.langUI = Language.ru,
    this.langArticles = const [Language.ru],
    this.articles = const [],
  });

  final ArticleMostReadingStatus status;
  final String error;
  final Language langUI;
  final List<Language> langArticles;
  final List<PublicationCommon> articles;

  MostReadingState copyWith({
    ArticleMostReadingStatus? status,
    String? error,
    Language? langUI,
    List<Language>? langArticles,
    List<PublicationCommon>? articles,
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
