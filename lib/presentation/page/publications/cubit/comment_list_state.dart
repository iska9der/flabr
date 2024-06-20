part of 'comment_list_cubit.dart';

enum CommentListStatus { initial, loading, success, failure }

class CommentListState extends Equatable {
  const CommentListState({
    this.status = CommentListStatus.initial,
    this.error = '',
    required this.publicationId,
    required this.source,
    this.list = CommentListResponse.empty,
  });

  final CommentListStatus status;
  final String error;

  final String publicationId;
  final PublicationSource source;
  final CommentListResponse list;

  CommentListState copyWith({
    CommentListStatus? status,
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
