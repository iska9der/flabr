import 'package:equatable/equatable.dart';

import '../../../common/exception/exception_helper.dart';
import '../../../common/model/network/list_response.dart';
import '../../publication/cubit/publication_list_cubit.dart';
import '../../publication/model/comment/comment_model.dart';
import '../../publication/model/publication/publication.dart';
import '../model/user_bookmarks_type.dart';

part 'user_bookmark_list_state.dart';

class UserBookmarkListCubit
    extends PublicationListCubit<UserBookmarkListState> {
  UserBookmarkListCubit({
    required super.repository,
    required super.languageRepository,
    String user = '',
    UserBookmarksType type = UserBookmarksType.articles,
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
        type: state.type,
      );

      emit(state.copyWith(
        status: PublicationListStatus.success,
        publications: [...state.publications, ...response.refs],
        page: state.page + 1,
        pagesCount: response.pagesCount,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: ExceptionHelper.parseMessage(e, 'Не удалось получить закладки'),
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

  changeType(UserBookmarksType type) {
    if (type == state.type) return;

    emit(UserBookmarkListState(user: state.user, type: type));
  }
}
