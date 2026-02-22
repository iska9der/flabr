part of 'hub_publication_list_cubit.dart';

class HubPublicationListState extends PublicationListState with Equatable {
  const HubPublicationListState({
    super.status = .initial,
    super.error = '',
    super.page = 1,
    super.response = const ListResponse<Publication>(),
    this.hub = '',
    this.filter = const FlowFilter(),
  });

  final String hub;
  final FlowFilter filter;

  HubPublicationListState copyWith({
    LoadingStatus? status,
    String? error,
    String? hub,
    FlowFilter? filter,
    int? page,
    ListResponse<Publication>? response,
  }) {
    return HubPublicationListState(
      status: status ?? this.status,
      error: error ?? this.error,
      hub: hub ?? this.hub,
      filter: filter ?? this.filter,
      page: page ?? this.page,
      response: response ?? this.response,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
    status,
    error,
    hub,
    filter,
    page,
    response,
  ];
}
