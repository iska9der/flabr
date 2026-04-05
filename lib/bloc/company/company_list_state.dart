part of 'company_list_cubit.dart';

class CompanyListState with EquatableMixin {
  const CompanyListState({
    this.status = .initial,
    this.error = '',
    this.response = CompanyListResponse.empty,
    this.page = 1,
  });

  final LoadingStatus status;
  final String error;
  final ListResponse<Company> response;
  final int page;

  bool get isFirstFetch => page == 1;
  bool get isLastPage => page >= response.pagesCount;

  CompanyListState copyWith({
    LoadingStatus? status,
    String? error,
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
