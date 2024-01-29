part of 'feed_publication_list_cubit.dart';

class FeedPublicationListState extends Equatable
    implements PublicationListState {
  const FeedPublicationListState({
    this.status = PublicationListStatus.initial,
    this.error = '',
    this.page = 1,
    this.pagesCount = 0,
    this.publications = const [],
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

  FeedPublicationListState copyWith({
    PublicationListStatus? status,
    String? error,
    int? page,
    int? pagesCount,
    List<Publication>? publications,
  }) {
    return FeedPublicationListState(
      status: status ?? this.status,
      error: error ?? this.error,
      page: page ?? this.page,
      pagesCount: pagesCount ?? this.pagesCount,
      publications: publications ?? this.publications,
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
      ];
}
