part of 'hub_list_cubit.dart';

enum HubListStatus { initial, loading, success, failure }

class HubListState extends Equatable {
  const HubListState({
    this.status = HubListStatus.initial,
    this.error = '',
    this.langUI = LanguageEnum.ru,
    this.langArticles = const [LanguageEnum.ru],
    this.list = HubListResponse.empty,
    this.page = 1,
  });

  final HubListStatus status;
  final LanguageEnum langUI;
  final List<LanguageEnum> langArticles;
  final String error;
  final HubListResponse list;
  final int page;

  bool get isFirstFetch => page == 1;
  bool get isLastPage => page >= list.pagesCount;

  HubListState copyWith({
    HubListStatus? status,
    String? error,
    HubListResponse? list,
    int? page,
  }) {
    return HubListState(
      status: status ?? this.status,
      error: error ?? this.error,
      langUI: langUI,
      langArticles: langArticles,
      list: list ?? this.list,
      page: page ?? this.page,
    );
  }

  @override
  List<Object> get props => [status, error, langUI, langArticles, list, page];
}
