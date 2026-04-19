import 'package:equatable/equatable.dart';

import '../../data/exception/exception.dart';
import '../../data/model/list_response_model.dart';
import '../../data/model/loading_status_enum.dart';
import '../../data/model/publication/publication.dart';
import '../../data/model/user/user.dart';
import '../../feature/publication_list/publication_list.dart';

part 'user_publication_list_state.dart';

class UserPublicationListCubit
    extends PublicationListCubit<UserPublicationListState> {
  UserPublicationListCubit({
    required super.repository,
    required super.languageRepository,
    String user = '',
    UserPublicationType type = UserPublicationType.articles,
  }) : super(UserPublicationListState(alias: user, type: type));

  @override
  Future<void> fetch() async {
    if (fetchDisabled) {
      return;
    }

    emit(state.copyWith(status: .loading));

    try {
      final response = await repository.fetchUserPublications(
        user: state.alias,
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
          error: e.parseException('Не удалось получить статьи'),
          status: .failure,
        ),
      );

      rethrow;
    }
  }

  @override
  void reset() {
    emit(.new(alias: state.alias, type: state.type));
  }

  void changeType(UserPublicationType type) {
    if (state.type == type) return;

    emit(.new(alias: state.alias, type: type));
  }
}
