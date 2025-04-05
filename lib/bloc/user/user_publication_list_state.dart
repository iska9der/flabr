part of 'user_publication_list_cubit.dart';

class UserPublicationListState extends PublicationListState
    with EquatableMixin {
  const UserPublicationListState({
    super.status = PublicationListStatus.initial,
    super.error = '',
    super.page = 1,
    super.pagesCount = 0,
    super.publications = const [],
    this.user = '',
    this.type = UserPublicationType.articles,
    this.sort = Sort.byNew,
    this.period = FilterList.dateDefault,
    this.score = FilterList.scoreDefault,
  });

  final String user;
  final UserPublicationType type;
  final Sort sort;
  final FilterOption period;
  final FilterOption score;

  UserPublicationListState copyWith({
    PublicationListStatus? status,
    String? error,
    String? user,
    UserPublicationType? type,
    Sort? sort,
    FilterOption? period,
    FilterOption? score,
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
