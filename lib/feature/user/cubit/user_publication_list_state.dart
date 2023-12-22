part of 'user_publication_list_cubit.dart';

class UserPublicationListState extends Equatable
    implements PublicationListState {
  const UserPublicationListState({
    this.status = PublicationListStatus.initial,
    this.error = '',
    this.user = '',
    this.type = PublicationType.article,
    this.sort = SortEnum.byNew,
    this.period = DatePeriodEnum.daily,
    this.score = '',
    this.page = 1,
    this.pagesCount = 0,
    this.publications = const [],
  });

  @override
  final PublicationListStatus status;
  @override
  final String error;
  final String user;
  final PublicationType type;
  final SortEnum sort;
  final DatePeriodEnum period;
  final String score;
  @override
  final int page;
  @override
  final int pagesCount;
  @override
  final List<Publication> publications;

  UserPublicationListState copyWith({
    PublicationListStatus? status,
    String? error,
    String? user,
    PublicationType? type,
    SortEnum? sort,
    DatePeriodEnum? period,
    String? score,
    int? page,
    int? pagesCount,
    List<Publication>? publications,
  }) {
    return UserPublicationListState(
      status: status ?? this.status,
      error: error ?? this.error,
      user: user ?? this.user,
      type: type ?? this.type,
      sort: sort ?? this.sort,
      period: period ?? this.period,
      score: score ?? this.score,
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
        user,
        type,
        sort,
        period,
        score,
        page,
        pagesCount,
        publications,
      ];
}
