part of 'company_list_cubit.dart';

class CompanyListState with EquatableMixin {
  const CompanyListState({
    this.status = .initial,
    this.error = '',
    this.list = CompanyListResponse.empty,
    this.page = 1,
  });

  final LoadingStatus status;
  final String error;
  final ListResponse<Company> list;
  final int page;

  bool get isFirstFetch => page == 1;
  bool get isLastPage => page >= list.pagesCount;

  CompanyListState copyWith({
    LoadingStatus? status,
    String? error,
    ListResponse<Company>? list,
    int? page,
  }) {
    return CompanyListState(
      status: status ?? this.status,
      error: error ?? this.error,
      list: list ?? this.list,
      page: page ?? this.page,
    );
  }

  @override
  List<Object> get props => [status, error, list, page];
}
