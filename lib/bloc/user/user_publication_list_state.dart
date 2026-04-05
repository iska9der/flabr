part of 'user_publication_list_cubit.dart';

class UserPublicationListState extends PublicationListState
    with EquatableMixin {
  const UserPublicationListState({
    super.status = PublicationListStatus.initial,
    super.error = '',
    super.page = 1,
    super.response = const ListResponse<Publication>(),
    required this.alias,
    this.type = UserPublicationType.articles,
  });

  final String alias;
  final UserPublicationType type;

  UserPublicationListState copyWith({
    PublicationListStatus? status,
    String? error,
    int? page,
    ListResponse<Publication>? response,
    String? alias,
    UserPublicationType? type,
  }) {
    return UserPublicationListState(
      status: status ?? this.status,
      error: error ?? this.error,
      page: page ?? this.page,
      response: response ?? this.response,
      alias: alias ?? this.alias,
      type: type ?? this.type,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
    status,
    error,
    page,
    response,
    alias,
    type,
  ];
}
