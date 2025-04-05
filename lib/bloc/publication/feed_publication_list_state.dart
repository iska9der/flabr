part of 'feed_publication_list_cubit.dart';

class FeedPublicationListState extends PublicationListState
    with EquatableMixin {
  const FeedPublicationListState({
    super.status = PublicationListStatus.initial,
    super.error = '',
    super.page = 1,
    super.pagesCount = 0,
    super.publications = const [],
    this.filter = const FeedFilter(),
  });

  final FeedFilter filter;

  FeedPublicationListState copyWith({
    PublicationListStatus? status,
    String? error,
    int? page,
    int? pagesCount,
    List<Publication>? publications,
    FeedFilter? filter,
  }) {
    return FeedPublicationListState(
      status: status ?? this.status,
      error: error ?? this.error,
      page: page ?? this.page,
      pagesCount: pagesCount ?? this.pagesCount,
      publications: publications ?? this.publications,
      filter: filter ?? this.filter,
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
        filter,
      ];
}
