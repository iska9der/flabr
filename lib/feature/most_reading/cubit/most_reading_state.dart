// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'most_reading_cubit.dart';

class MostReadingState extends Equatable {
  const MostReadingState({
    this.status = LoadingStatus.initial,
    this.error = '',
    this.langUI = Language.ru,
    this.langArticles = const [Language.ru],
    this.publications = const [],
  });

  final LoadingStatus status;
  final String error;
  final Language langUI;
  final List<Language> langArticles;
  final List<PublicationCommon> publications;

  MostReadingState copyWith({
    LoadingStatus? status,
    String? error,
    Language? langUI,
    List<Language>? langArticles,
    List<PublicationCommon>? publications,
  }) {
    return MostReadingState(
      status: status ?? this.status,
      error: error ?? this.error,
      langUI: langUI ?? this.langUI,
      langArticles: langArticles ?? this.langArticles,
      publications: publications ?? this.publications,
    );
  }

  @override
  List<Object> get props => [status, error, langUI, langArticles, publications];
}
