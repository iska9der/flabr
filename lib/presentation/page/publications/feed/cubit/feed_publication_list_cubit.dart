import 'package:equatable/equatable.dart';

import '../../../../../data/exception/part.dart';
import '../../../../../data/model/filter/part.dart';
import '../../../../../data/model/list_response/list_response.dart';
import '../../../../../data/model/publication/publication.dart';
import '../../../../feature/publication_list/part.dart';

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
        filter: state.filter,
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

  void applyFilter(FeedFilter newFilter) {
    if (state.filter == newFilter) {
      return;
    }

    emit(FeedPublicationListState(filter: newFilter));
  }
}
