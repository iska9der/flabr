import 'dart:async';

import 'package:equatable/equatable.dart';

import '../../data/exception/exception.dart';
import '../../data/model/list_response_model.dart';
import '../../data/model/loading_status_enum.dart';
import '../../data/model/publication/publication.dart';
import '../../data/model/user/user.dart';
import '../../feature/publication_list/publication_list.dart';

part 'user_bookmark_list_state.dart';

class UserBookmarkListCubit
    extends PublicationListCubit<UserBookmarkListState> {
  UserBookmarkListCubit({
    required super.repository,
    required super.languageRepository,
    String user = '',
    UserBookmarksType type = UserBookmarksType.articles,
  }) : super(UserBookmarkListState(user: user, type: type));

  @override
  Future<void> fetch() async {
    if (fetchDisabled) {
      return;
    }

    emit(state.copyWith(status: .loading));

    try {
      final response = await repository.fetchUserBookmarks(
        user: state.user,
        page: state.page.toString(),
        type: state.type,
      );

      emit(
        state.copyWith(
          status: .success,
          response: state.response.merge(response, getId: (ref) => ref.id),
          page: state.page + 1,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          error: e.parseException('Не удалось получить закладки'),
          status: .failure,
        ),
      );

      rethrow;
    }
  }

  @override
  void reset() {
    emit(.new(user: state.user, type: state.type));
  }

  void changeType(UserBookmarksType type) {
    if (type == state.type) return;

    emit(.new(user: state.user, type: type));
  }
}
