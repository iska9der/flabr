part of 'hub_list_cubit.dart';

class HubListState with Equatable {
  const HubListState({
    this.status = .initial,
    this.error = '',
    this.list = HubListResponse.empty,
    this.page = 1,
  });

  final LoadingStatus status;
  final Object error;
  final ListResponse<Hub> list;
  final int page;

  int get currentPage => status == .success && page > 1 ? page - 1 : page;
  bool get isLastPage => list.pagesCount > 0 && currentPage >= list.pagesCount;

  HubListState copyWith({
    LoadingStatus? status,
    Object? error,
    ListResponse<Hub>? list,
    int? page,
  }) {
    return HubListState(
      status: status ?? this.status,
      error: error ?? this.error,
      list: list ?? this.list,
      page: page ?? this.page,
    );
  }

  @override
  List<Object> get props => [status, error, list, page];
}
