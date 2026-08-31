part of 'summary_cubit.dart';

enum SummaryStatus { initial, loading, failure, success }

class SummaryState with Equatable {
  const SummaryState({
    this.status = .initial,
    this.error = '',
    required this.url,
    this.model = SummaryModel.empty,
  });

  final SummaryStatus status;
  final Object error;
  final String url;
  final SummaryModel model;

  SummaryState copyWith({
    SummaryStatus? status,
    Object? error,
    SummaryModel? model,
  }) {
    return SummaryState(
      url: url,
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
    );
  }

  @override
  List<Object> get props => [status, error, url, model];
}
