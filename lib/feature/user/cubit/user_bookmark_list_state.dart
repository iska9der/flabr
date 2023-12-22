part of 'user_bookmark_list_cubit.dart';

class UserBookmarkListState extends Equatable implements PublicationListState {
  const UserBookmarkListState({
    this.status = PublicationListStatus.initial,
    this.error = '',
    this.user = '',
    this.type = PublicationType.article,
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
  @override
  final int page;
  @override
  final int pagesCount;
  @override
  final List<Publication> publications;

  UserBookmarkListState copyWith({
    PublicationListStatus? status,
    String? error,
    String? user,
    PublicationType? type,
    int? page,
    int? pagesCount,
    List<Publication>? publications,
  }) {
    return UserBookmarkListState(
      status: status ?? this.status,
      error: error ?? this.error,
      user: user ?? this.user,
      type: type ?? this.type,
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
        page,
        pagesCount,
        publications,
      ];
}
