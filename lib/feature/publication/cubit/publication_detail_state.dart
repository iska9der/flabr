part of 'publication_detail_cubit.dart';

enum ArticleStatus { initial, loading, success, failure }

class PublicationDetailState extends Equatable {
  const PublicationDetailState({
    this.status = ArticleStatus.initial,
    this.error = '',
    required this.id,
    required this.source,
    required this.article,
  });

  final ArticleStatus status;
  final String error;

  final String id;
  final PublicationSource source;
  final ArticleModel article;

  PublicationDetailState copyWith({
    ArticleStatus? status,
    String? error,
    ArticleModel? article,
  }) {
    return PublicationDetailState(
      id: id,
      source: source,
      status: status ?? this.status,
      error: error ?? this.error,
      article: article ?? this.article,
    );
  }

  @override
  List<Object> get props => [
        status,
        error,
        id,
        source,
        article,
      ];
}
