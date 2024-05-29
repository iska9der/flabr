part of 'feed_publication_list_cubit.dart';

class FeedPublicationListState extends Equatable
    implements PublicationListState {
  const FeedPublicationListState({
    this.status = PublicationListStatus.initial,
    this.error = '',
    this.page = 1,
    this.pagesCount = 0,
    this.publications = const [],
    this.score = ScoreEnum.all,
    this.types = availableTypes,
  });

  @override
  final PublicationListStatus status;
  @override
  final String error;
  @override
  final int page;
  @override
  final int pagesCount;
  @override
  final List<Publication> publications;

  /// Filters
  final ScoreEnum score;
  final List<PublicationType> types;
  static const List<PublicationType> availableTypes = [
    PublicationType.article,
    PublicationType.post,
    PublicationType.news,
  ];

  FeedPublicationListState copyWith({
    PublicationListStatus? status,
    String? error,
    int? page,
    int? pagesCount,
    List<Publication>? publications,
    ScoreEnum? score,
    List<PublicationType>? types,
  }) {
    return FeedPublicationListState(
      status: status ?? this.status,
      error: error ?? this.error,
      page: page ?? this.page,
      pagesCount: pagesCount ?? this.pagesCount,
      publications: publications ?? this.publications,
      score: score ?? this.score,
      types: types ?? this.types,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        status,
        error,
        page,
        pagesCount,
        publications,
        score,
        types,
      ];
}
