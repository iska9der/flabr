// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'summary_cubit.dart';

enum SummaryStatus { initial, loading, failure, success }

class SummaryState extends Equatable {
  const SummaryState({
    this.status = SummaryStatus.initial,
    this.error = '',
    required this.publicationId,
    this.model = SummaryModel.empty,
  });

  final SummaryStatus status;
  final String error;
  final String publicationId;
  final SummaryModel model;

  SummaryState copyWith({
    SummaryStatus? status,
    String? error,
    SummaryModel? model,
  }) {
    return SummaryState(
      publicationId: publicationId,
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
    );
  }

  @override
  List<Object> get props => [status, error, publicationId, model];
}
