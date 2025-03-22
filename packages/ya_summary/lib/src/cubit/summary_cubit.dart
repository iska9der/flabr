import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/summary_exception.dart';
import '../data/summary_model.dart';
import '../data/summary_repository.dart';

part 'summary_state.dart';

class SummaryCubit extends Cubit<SummaryState> {
  SummaryCubit({
    required String url,
    required SummaryRepository repository,
  })  : _repository = repository,
        super(SummaryState(url: url));

  final SummaryRepository _repository;

  void fetchSummary() async {
    try {
      emit(state.copyWith(status: SummaryStatus.loading));

      final model = await _repository.fetchSummary(state.url);

      emit(state.copyWith(status: SummaryStatus.success, model: model));
    } on SummaryException catch (e) {
      emit(state.copyWith(
        status: SummaryStatus.failure,
        error: e.toString(),
      ));
    } catch (error, stackTrace) {
      emit(state.copyWith(
        status: SummaryStatus.failure,
        error: 'Не удалось получить краткий пересказ',
      ));

      super.onError(error, stackTrace);
    }
  }
}
