part of 'flow_publication_list_cubit.dart';

class FlowPublicationListState extends PublicationListState
    with EquatableMixin {
  const FlowPublicationListState({
    super.status = PublicationListStatus.initial,
    super.error = '',
    super.page = 1,
    super.pagesCount = 0,
    super.publications = const [],
    this.flow = PublicationFlow.all,
    this.section = Section.article,
    this.filter = const FlowFilter(),
  });

  final PublicationFlow flow;
  final Section section;
  final FlowFilter filter;

  FlowPublicationListState copyWith({
    PublicationListStatus? status,
    String? error,
    PublicationFlow? flow,
    Section? section,
    FlowFilter? filter,
    int? page,
    int? pagesCount,
    List<Publication>? publications,
  }) {
    return FlowPublicationListState(
      status: status ?? this.status,
      error: error ?? this.error,
      flow: flow ?? this.flow,
      section: section ?? this.section,
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
        section,
        filter,
        page,
        pagesCount,
        publications,
      ];
}
