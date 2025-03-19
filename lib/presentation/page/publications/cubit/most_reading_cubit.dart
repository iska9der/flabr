import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/exception/part.dart';
import '../../../../data/model/language/part.dart';
import '../../../../data/model/publication/publication.dart';
import '../../../../data/repository/part.dart';
import '../../../extension/extension.dart';

part 'most_reading_state.dart';

class MostReadingCubit extends Cubit<MostReadingState> {
  MostReadingCubit(PublicationRepository repository)
      : _repository = repository,
        super(const MostReadingState());

  final PublicationRepository _repository;

  void fetch() async {
    if (state.status.isLoading || state.articles.isNotEmpty) {
      return;
    }

    emit(state.copyWith(status: ArticleMostReadingStatus.loading));

    try {
      final articles = await _repository.fetchMostReading(
        langUI: state.langUI,
        langArticles: state.langArticles,
      );

      emit(state.copyWith(
        status: ArticleMostReadingStatus.success,
        articles: articles,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: ExceptionHelper.parseMessage(e, 'Не удалось получить статьи'),
        status: ArticleMostReadingStatus.failure,
      ));
    }
  }
}
