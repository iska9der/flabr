import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/model/summary_model.dart';
import '../../../../data/repository/part.dart';

part 'summary_state.dart';

class SummaryCubit extends Cubit<SummaryState> {
  SummaryCubit({
    required String publicationId,
    required SummaryRepository repository,
  })  : _repository = repository,
        super(SummaryState(publicationId: publicationId));

  final SummaryRepository _repository;

  void fetchSummary() async {
    try {
      emit(state.copyWith(status: SummaryStatus.loading));

      final model = await _repository.fetchArticleSummary(state.publicationId);

      emit(state.copyWith(status: SummaryStatus.success, model: model));
    } catch (e) {
      emit(state.copyWith(
        status: SummaryStatus.failure,
        error: 'Не удалось получить краткий пересказ',
      ));

      rethrow;
    }
  }
}
