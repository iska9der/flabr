part of 'company_list_cubit.dart';

class CompanyListState with Equatable {
  const CompanyListState({
    this.status = .initial,
    this.error = '',
    this.response = CompanyListResponse.empty,
    this.page = 1,
  });

  final LoadingStatus status;
  final Object error;
  final ListResponse<Company> response;
  final int page;

  int get currentPage => status == .success && page > 1 ? page - 1 : page;
  bool get isLastPage =>
      response.pagesCount > 0 && currentPage >= response.pagesCount;

  CompanyListState copyWith({
    LoadingStatus? status,
    Object? error,
    ListResponse<Company>? response,
    int? page,
  }) {
    return CompanyListState(
      status: status ?? this.status,
      error: error ?? this.error,
      response: response ?? this.response,
      page: page ?? this.page,
    );
  }

  @override
  List<Object> get props => [status, error, response, page];
}
