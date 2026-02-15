part of 'publication_detail_cubit.dart';

class PublicationDetailState with EquatableMixin {
  const PublicationDetailState({
    this.status = LoadingStatus.initial,
    this.error = '',
    required this.id,
    required this.source,
    required this.publication,
  });

  final LoadingStatus status;
  final String error;

  final String id;
  final PublicationSource source;
  final Publication publication;

  PublicationDetailState copyWith({
    LoadingStatus? status,
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
