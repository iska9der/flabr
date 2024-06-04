import 'package:equatable/equatable.dart';

import '../../../../../data/exception/part.dart';
import '../../../../../data/model/list_response/list_response.dart';
import '../../../../../data/model/publication/publication.dart';
import '../../../../../data/model/sort/sort_option_model.dart';
import '../../../../../data/model/sort/sort_score_enum.dart';
import '../../../../cubit/publication_list_cubit.dart';
import '../model/feed_publication_type.dart';

part 'feed_publication_list_state.dart';

class FeedPublicationListCubit
    extends PublicationListCubit<FeedPublicationListState> {
  FeedPublicationListCubit({
    required super.repository,
    required super.languageRepository,
  }) : super(const FeedPublicationListState());

  @override
  bool get showType => true;

  @override
  Future<void> fetch() async {
    if (state.status == PublicationListStatus.loading ||
        !isFirstFetch && isLastPage) {
      return;
    }

    emit(state.copyWith(status: PublicationListStatus.loading));

    try {
      ListResponse response = await repository.fetchFeed(
        langUI: languageRepository.ui,
        langArticles: languageRepository.articles,
        page: state.page.toString(),
        score: state.score,
        types: state.types,
      );

      emit(state.copyWith(
        status: PublicationListStatus.success,
        publications: [...state.publications, ...response.refs],
        page: state.page + 1,
        pagesCount: response.pagesCount,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: ExceptionHelper.parseMessage(
          e,
          'Не удалось получить публикации',
        ),
        status: PublicationListStatus.failure,
      ));

      rethrow;
    }
  }

  @override
  void refetch() {
    emit(state.copyWith(
      status: PublicationListStatus.initial,
      page: 1,
      publications: [],
      pagesCount: 0,
    ));
  }

  void changeFilterScore(SortOption option) {
    final newScore = SortScore.fromString(option.value);

    if (state.score == newScore) {
      return;
    }

    emit(FeedPublicationListState(types: state.types, score: newScore));
  }

  void changeFilterTypes(List<FeedPublicationType> types) {
    /// Выбран хотя бы один тип публикации
    if (types.isEmpty) {
      return;
    }

    emit(FeedPublicationListState(score: state.score, types: types));
  }
}
