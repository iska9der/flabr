part of 'flow_publication_list_cubit.dart';

class FlowPublicationListState extends Equatable
    implements PublicationListState {
  const FlowPublicationListState({
    this.status = PublicationListStatus.initial,
    this.error = '',
    this.page = 1,
    this.pagesCount = 0,
    this.publications = const [],
    this.flow = PublicationFlow.all,
    this.type = FlowFilterPublication.article,
    this.filter = const FlowFilter(),
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

  final PublicationFlow flow;
  final FlowFilterPublication type;
  final FlowFilter filter;

  FlowPublicationListState copyWith({
    PublicationListStatus? status,
    String? error,
    PublicationFlow? flow,
    FlowFilterPublication? type,
    FlowFilter? filter,
    int? page,
    int? pagesCount,
    List<Publication>? publications,
  }) {
    return FlowPublicationListState(
      status: status ?? this.status,
      error: error ?? this.error,
      flow: flow ?? this.flow,
      type: type ?? this.type,
      filter: filter ?? this.filter,
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
        filter,
        page,
        pagesCount,
        publications,
      ];
}
