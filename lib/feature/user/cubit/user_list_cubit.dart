import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/exception/exception_helper.dart';
import '../../../component/localization/language_enum.dart';
import '../model/user_model.dart';
import '../repository/user_repository.dart';

part 'user_list_state.dart';

class UserListCubit extends Cubit<UserListState> {
  UserListCubit(
    UserRepository repository, {
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
  })  : _repository = repository,
        super(UserListState(langUI: langUI, langArticles: langArticles));

  final UserRepository _repository;

  bool get isFirstFetch => state.page == 1;
  bool get isLastPage => state.page >= state.pagesCount;

  void fetchAll() async {
    if (state.status == UserListStatus.loading || !isFirstFetch && isLastPage) {
      return;
    }

    emit(state.copyWith(status: UserListStatus.loading));

    try {
      var response = await _repository.fetchAll(
        langUI: state.langUI,
        langArticles: state.langArticles,
        page: state.page.toString(),
      );

      emit(state.copyWith(
        status: UserListStatus.success,
        users: [...state.users, ...response.refs],
        page: state.page + 1,
        pagesCount: response.pagesCount,
      ));
    } catch (e) {
      const fallbackMessage = 'Не удалось получить пользователей';

      emit(state.copyWith(
        error: ExceptionHelper.parseMessage(e, fallbackMessage),
        status: UserListStatus.failure,
      ));
    }
  }

  changeLanguages({
    LanguageEnum? langUI,
    List<LanguageEnum>? langArticles,
  }) {
    emit(UserListState(
      langUI: langUI ?? state.langUI,
      langArticles: langArticles ?? state.langArticles,
    ));
  }
}
