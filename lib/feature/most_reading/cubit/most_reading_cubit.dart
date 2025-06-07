import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/exception/exception.dart';
import '../../../data/model/language/language.dart';
import '../../../data/model/loading_status_enum.dart';
import '../../../data/model/publication/publication.dart';
import '../../../data/repository/repository.dart';

part 'most_reading_state.dart';

class MostReadingCubit extends Cubit<MostReadingState> {
  MostReadingCubit({required PublicationRepository repository})
    : _repository = repository,
      super(const MostReadingState());

  final PublicationRepository _repository;

  void fetch() async {
    if (state.status == LoadingStatus.loading ||
        state.publications.isNotEmpty) {
      return;
    }

    emit(state.copyWith(status: LoadingStatus.loading));

    try {
      final models = await _repository.fetchMostReading();

      emit(state.copyWith(status: LoadingStatus.success, publications: models));
    } catch (e) {
      emit(
        state.copyWith(
          error: e.parseException('Не удалось получить статьи'),
          status: LoadingStatus.failure,
        ),
      );
    }
  }
}
