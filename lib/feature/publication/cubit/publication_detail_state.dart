part of 'publication_detail_cubit.dart';

enum PublicationStatus { initial, loading, success, failure }

class PublicationDetailState extends Equatable {
  const PublicationDetailState({
    this.status = PublicationStatus.initial,
    this.error = '',
    required this.id,
    required this.source,
    required this.publication,
  });

  final PublicationStatus status;
  final String error;

  final String id;
  final PublicationSource source;
  final Publication publication;

  PublicationDetailState copyWith({
    PublicationStatus? status,
    String? error,
    Publication? publication,
  }) {
    return PublicationDetailState(
      id: id,
      source: source,
      status: status ?? this.status,
      error: error ?? this.error,
      publication: publication ?? this.publication,
    );
  }

  @override
  List<Object> get props => [
        status,
        error,
        id,
        source,
        publication,
      ];
}
