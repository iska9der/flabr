part of 'search_cubit.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.initial,
    this.error = '',
    this.query = '',
    this.target = SearchTarget.posts,
    this.order = SearchOrder.relevance,
    this.listResponse = ListResponse.empty,
    this.page = 1,
  });

  final SearchStatus status;
  final String error;

  final String query;
  final SearchOrder order;
  final SearchTarget target;
  final ListResponse<dynamic> listResponse;
  final int page;

  bool get isFirstFetch => page == 1;
  bool get isLastPage => page >= listResponse.pagesCount;

  SearchState copyWith({
    SearchStatus? status,
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
