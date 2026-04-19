part of 'flow_publication_list_cubit.dart';

class FlowPublicationListState extends PublicationListState
    with EquatableMixin {
  const FlowPublicationListState({
    super.status = .initial,
    super.error = '',
    super.page = 1,
    super.response = const ListResponse<Publication>(),
    this.flow = PublicationFlow.all,
    this.section = Section.article,
    this.filter = const FlowFilter(),
  });

  final PublicationFlow flow;
  final Section section;
  final FlowFilter filter;

  FlowPublicationListState copyWith({
    LoadingStatus? status,
    String? error,
    int? page,
    ListResponse<Publication>? response,
    PublicationFlow? flow,
    Section? section,
    FlowFilter? filter,
  }) {
    return FlowPublicationListState(
      status: status ?? this.status,
      error: error ?? this.error,
      page: page ?? this.page,
      response: response ?? this.response,
      flow: flow ?? this.flow,
      section: section ?? this.section,
      filter: filter ?? this.filter,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
    status,
    error,
    flow,
    section,
    filter,
    page,
    response,
  ];
}
