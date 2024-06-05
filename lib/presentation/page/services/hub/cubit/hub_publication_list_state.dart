part of 'hub_publication_list_cubit.dart';

class HubPublicationListState extends Equatable
    implements PublicationListState {
  const HubPublicationListState({
    this.status = PublicationListStatus.initial,
    this.error = '',
    this.page = 1,
    this.pagesCount = 0,
    this.publications = const [],
    this.hub = '',
    this.type = PublicationType.article,
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
  final String hub;
  final PublicationType type;
  final FlowFilter filter;

  HubPublicationListState copyWith({
    PublicationListStatus? status,
    String? error,
    String? hub,
    PublicationType? type,
    FlowFilter? filter,
    int? page,
    int? pagesCount,
    List<Publication>? publications,
  }) {
    return HubPublicationListState(
      status: status ?? this.status,
      error: error ?? this.error,
      hub: hub ?? this.hub,
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
        hub,
        type,
        filter,
        page,
        pagesCount,
        publications,
      ];
}
