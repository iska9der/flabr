part of 'hub_publication_list_cubit.dart';

class HubPublicationListState extends PublicationListState with EquatableMixin {
  const HubPublicationListState({
    super.status = PublicationListStatus.initial,
    super.error = '',
    super.page = 1,
    super.pagesCount = 0,
    super.publications = const [],
    this.hub = '',
    this.type = PublicationType.article,
    this.filter = const FlowFilter(),
  });

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
