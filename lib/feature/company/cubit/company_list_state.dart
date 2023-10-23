part of 'company_list_cubit.dart';

enum CompanyListStatus { initial, loading, success, failure }

class CompanyListState extends Equatable {
  const CompanyListState({
    this.status = CompanyListStatus.initial,
    this.error = '',
    this.list = CompanyListResponse.empty,
    this.page = 1,
  });

  final CompanyListStatus status;
  final String error;
  final CompanyListResponse list;
  final int page;

  bool get isFirstFetch => page == 1;
  bool get isLastPage => page >= list.pagesCount;

  CompanyListState copyWith({
    CompanyListStatus? status,
    String? error,
    CompanyListResponse? list,
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
