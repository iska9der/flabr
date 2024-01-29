part of 'flow_publication_list_cubit.dart';

class FlowPublicationListState extends Equatable
    implements PublicationListState {
  const FlowPublicationListState({
    this.status = PublicationListStatus.initial,
    this.error = '',
    this.page = 1,
    this.pagesCount = 0,
    this.publications = const [],
    this.flow = FlowEnum.all,
    this.type = PublicationType.article,
    this.sort = SortEnum.byNew,
    this.period = DatePeriodEnum.daily,
    this.score = '',
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

  final FlowEnum flow;
  final PublicationType type;
  final SortEnum sort;
  final DatePeriodEnum period;
  final String score;

  FlowPublicationListState copyWith({
    PublicationListStatus? status,
    String? error,
    FlowEnum? flow,
    PublicationType? type,
    SortEnum? sort,
    DatePeriodEnum? period,
    String? score,
    int? page,
    int? pagesCount,
    List<Publication>? publications,
  }) {
    return FlowPublicationListState(
      status: status ?? this.status,
      error: error ?? this.error,
      flow: flow ?? this.flow,
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
        flow,
        type,
        sort,
        period,
        score,
        page,
        pagesCount,
        publications,
      ];
}
