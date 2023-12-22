import 'package:equatable/equatable.dart';

import '../../../common/cubit/publication_list.dart';
import '../../../common/exception/exception_helper.dart';
import '../../../common/model/network/list_response.dart';
import '../../publication/model/publication/publication.dart';
import '../../publication/model/publication_type.dart';

part 'user_bookmark_list_state.dart';

class UserBookmarkListCubit extends PublicationListC<UserBookmarkListState> {
  UserBookmarkListCubit({
    required super.repository,
    required super.languageRepository,
    String user = '',
    PublicationType type = PublicationType.article,
  }) : super(UserBookmarkListState(
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
      ListResponse response = await repository.fetchUserBookmarks(
        langUI: languageRepository.ui,
        langArticles: languageRepository.articles,
        user: state.user,
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
