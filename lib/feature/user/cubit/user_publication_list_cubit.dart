import 'package:equatable/equatable.dart';

import '../../../common/cubit/publication_list.dart';
import '../../../common/exception/exception_helper.dart';
import '../../../common/model/network/list_response.dart';
import '../../publication/model/publication/publication.dart';
import '../../publication/model/publication_type.dart';
import '../../publication/model/sort/date_period_enum.dart';
import '../../publication/model/sort/sort_enum.dart';

part 'user_publication_list_state.dart';

class UserPublicationListCubit
    extends PublicationListC<UserPublicationListState> {
  UserPublicationListCubit({
    required super.repository,
    required super.languageRepository,
    String user = '',
    PublicationType type = PublicationType.article,
  }) : super(UserPublicationListState(
          user: user,
          type: type,
        ));

  @override
  Future<void> fetch() async {
    if (state.status == PublicationListStatus.loading ||
        !isFirstFetch && isLastPage) {
      return;
    }

    emit(state.copyWith(status: PublicationListStatus.loading));

    try {
      ListResponse response = await repository.fetchUserArticles(
        langUI: languageRepository.ui,
        langArticles: languageRepository.articles,
        user: state.user,
        sort: state.sort,
        period: state.period,
        score: state.score,
        page: state.page.toString(),
      );

      emit(state.copyWith(
        status: PublicationListStatus.success,
        publications: [...state.publications, ...response.refs],
        page: state.page + 1,
        pagesCount: response.pagesCount,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: ExceptionHelper.parseMessage(e, 'Не удалось получить статьи'),
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
}
