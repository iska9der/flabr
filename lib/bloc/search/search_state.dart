part of 'search_cubit.dart';

class SearchState with EquatableMixin {
  const SearchState({
    this.status = .initial,
    this.error = '',
    this.query = '',
    this.target = .posts,
    this.order = .relevance,
    this.listResponse = .empty,
    this.page = 1,
  });

  final LoadingStatus status;
  final String error;

  final String query;
  final SearchOrder order;
  final SearchTarget target;
  final ListResponse<dynamic> listResponse;
  final int page;

  bool get isFirstFetch => page == 1;
  bool get isLastPage => page >= listResponse.pagesCount;

  SearchState copyWith({
    LoadingStatus? status,
    String? error,
    String? query,
    SearchOrder? order,
    SearchTarget? target,
    ListResponse<dynamic>? listResponse,
    int? page,
  }) {
    return SearchState(
      status: status ?? this.status,
      error: error ?? this.error,
      query: query ?? this.query,
      order: order ?? this.order,
      target: target ?? this.target,
      listResponse: listResponse ?? this.listResponse,
      page: page ?? this.page,
    );
  }

  @override
  List<Object> get props => [
    status,
    error,
    query,
    order,
    target,
    listResponse,
    page,
  ];
}
