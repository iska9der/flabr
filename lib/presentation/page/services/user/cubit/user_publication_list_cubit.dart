import 'package:equatable/equatable.dart';

import '../../../../../data/exception/part.dart';
import '../../../../../data/model/filter/part.dart';
import '../../../../../data/model/list_response/list_response_model.dart';
import '../../../../../data/model/publication/publication.dart';
import '../../../../../data/model/user/user_publication_type.dart';
import '../../../../../feature/publication_list/publication_list.dart';

part 'user_publication_list_state.dart';

class UserPublicationListCubit
    extends PublicationListCubit<UserPublicationListState> {
  UserPublicationListCubit({
    required super.repository,
    required super.languageRepository,
    String user = '',
    UserPublicationType type = UserPublicationType.articles,
  }) : super(UserPublicationListState(
          user: user,
          type: type,
        ));

  @override
  Future<void> fetch() async {
    if (fetchDisabled) {
      return;
    }

    emit(state.copyWith(status: PublicationListStatus.loading));

    try {
      ListResponse response = await repository.fetchUserPublications(
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

  changeType(UserPublicationType type) {
    if (state.type == type) return;

    emit(UserPublicationListState(
      user: state.user,
      type: type,
    ));
  }
}
