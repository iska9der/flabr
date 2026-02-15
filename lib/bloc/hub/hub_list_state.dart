part of 'hub_list_cubit.dart';

class HubListState with EquatableMixin {
  const HubListState({
    this.status = .initial,
    this.error = '',
    this.list = HubListResponse.empty,
    this.page = 1,
  });

  final LoadingStatus status;
  final String error;
  final ListResponse<Hub> list;
  final int page;

  bool get isFirstFetch => page == 1;
  bool get isLastPage => page >= list.pagesCount;

  HubListState copyWith({
    LoadingStatus? status,
    String? error,
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
