part of 'publication_list_cubit.dart';

class PublicationListState extends Equatable implements PublicationListS {
  const PublicationListState({
    this.status = PublicationListStatus.initial,
    this.error = '',
    this.source = PublicationListSource.flow,
    this.flow = FlowEnum.all,
    this.hub = '',
    this.user = '',
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
  final PublicationListSource source;
  final FlowEnum flow;
  final String hub;
  final String user;
  final PublicationType type;
  final SortEnum sort;
  final DatePeriodEnum period;
  final String score;
  @override
  final int page;
  @override
  final int pagesCount;
  @override
  final List<Publication> publications;

  PublicationListState copyWith({
    PublicationListStatus? status,
    String? error,
    PublicationListSource? source,
    FlowEnum? flow,
    String? hub,
    String? user,
    PublicationType? type,
    SortEnum? sort,
    DatePeriodEnum? period,
    String? score,
    int? page,
    int? pagesCount,
    List<Publication>? publications,
  }) {
    return PublicationListState(
      status: status ?? this.status,
      error: error ?? this.error,
      source: source ?? this.source,
      flow: flow ?? this.flow,
      hub: hub ?? this.hub,
      user: user ?? this.user,
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
        source,
        flow,
        hub,
        user,
        type,
        sort,
        period,
        score,
        page,
        pagesCount,
        publications,
      ];
}
