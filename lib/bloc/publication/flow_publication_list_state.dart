part of 'flow_publication_list_cubit.dart';

class FlowPublicationListState extends PublicationListState with Equatable {
  const FlowPublicationListState({
    super.status = .initial,
    super.error = '',
    super.page = 1,
    super.response = const ListResponse<Publication>(),
    this.flow = PublicationFlow.all,
    this.filter = const FlowFilter(),
  });

  final PublicationFlow flow;
  final FlowFilter filter;

  FlowPublicationListState copyWith({
    LoadingStatus? status,
    Object? error,
    int? page,
    ListResponse<Publication>? response,
    PublicationFlow? flow,
    FlowFilter? filter,
  }) {
    return FlowPublicationListState(
      status: status ?? this.status,
      error: error ?? this.error,
      page: page ?? this.page,
      response: response ?? this.response,
      flow: flow ?? this.flow,
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
    filter,
    page,
    response,
  ];
}
