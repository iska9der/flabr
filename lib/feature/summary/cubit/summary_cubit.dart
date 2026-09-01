import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ya_summary/ya_summary.dart';

import '../../../bloc/error/app_failure.dart';
import '../../../data/repository/summary_repository.dart';

part 'summary_state.dart';

class SummaryCubit extends Cubit<SummaryState> {
  SummaryCubit({
    required String url,
    required this._repository,
  }) : super(SummaryState(url: url));

  final SummaryRepository _repository;

  Future<void> fetchSummary() async {
    emit(state.copyWith(status: .loading));

    try {
      final model = await _repository.fetchSummary(state.url);
      emit(state.copyWith(status: .success, model: model));
    } on SummaryException catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: .failure,
          error: AppFailure(_mapExceptionType(error.type), error),
        ),
      );

      super.onError(error, stackTrace);
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: .failure,
          error: AppFailure(.summaryOperationFailed, error),
        ),
      );

      super.onError(error, stackTrace);
    }
  }

  AppFailureType _mapExceptionType(SummaryExceptionType type) {
    return switch (type) {
      SummaryExceptionType.tokenMissing || SummaryExceptionType.unauthorized =>
        AppFailureType.summaryAuthorizationRequired,
      SummaryExceptionType.sharingUrlFetchFailed =>
        AppFailureType.summarySharingUrlFetchFailed,
      SummaryExceptionType.summaryFetchFailed =>
        AppFailureType.summaryFetchFailed,
    };
  }
}
