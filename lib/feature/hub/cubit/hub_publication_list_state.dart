part of 'hub_publication_list_cubit.dart';

class HubPublicationListState extends Equatable
    implements SortablePublicationListState {
  const HubPublicationListState({
    this.status = PublicationListStatus.initial,
    this.error = '',
    this.hub = '',
    this.type = PublicationType.article,
    this.sort = SortEnum.byNew,
    this.period = DatePeriodEnum.daily,
    this.score = '',
    this.page = 1,
    this.pagesCount = 0,
    this.publications = const [],
  });

  @override
  final PublicationListStatus status;
  @override
  final String error;
  final String hub;
  final PublicationType type;
  @override
  final SortEnum sort;
  @override
  final DatePeriodEnum period;
  @override
  final String score;
  @override
  final int page;
  @override
  final int pagesCount;
  @override
  final List<Publication> publications;

  HubPublicationListState copyWith({
    PublicationListStatus? status,
    String? error,
    String? hub,
    PublicationType? type,
    SortEnum? sort,
    DatePeriodEnum? period,
    String? score,
    int? page,
    int? pagesCount,
    List<Publication>? publications,
  }) {
    return HubPublicationListState(
      status: status ?? this.status,
      error: error ?? this.error,
      hub: hub ?? this.hub,
      type: type ?? this.type,
      sort: sort ?? this.sort,
      period: period ?? this.period,
      score: score ?? this.score,
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
        hub,
        type,
        sort,
        period,
        score,
        page,
        pagesCount,
        publications,
      ];
}
