part of 'comment_list_cubit.dart';

class CommentListState with EquatableMixin {
  const CommentListState({
    this.status = .initial,
    this.error = '',
    required this.publicationId,
    required this.source,
    this.list = CommentListResponse.empty,
  });

  final LoadingStatus status;
  final String error;

  final String publicationId;
  final PublicationSource source;
  final CommentListResponse list;

  CommentListState copyWith({
    LoadingStatus? status,
    String? error,
    Language? langUI,
    List<Language>? langArticles,
    CommentListResponse? list,
  }) {
    return CommentListState(
      publicationId: publicationId,
      source: source,
      status: status ?? this.status,
      error: error ?? this.error,
      list: list ?? this.list,
    );
  }

  @override
  List<Object> get props => [
    status,
    error,
    publicationId,
    source,
    list,
  ];
}
