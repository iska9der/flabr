import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/exception/exception_helper.dart';
import '../../../common/model/extension/enum_status.dart';
import '../../../data/model/language/language_part.dart';
import '../../../data/repository/repository_part.dart';
import '../model/publication/publication.dart';

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
