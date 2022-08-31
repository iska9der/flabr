import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/exception/displayable_exception.dart';
import '../../../component/localization/language_enum.dart';
import '../model/user_model.dart';
import '../service/user_service.dart';

part 'user_list_state.dart';

class UserListCubit extends Cubit<UserListState> {
  UserListCubit(
    UserService service, {
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
  })  : _service = service,
        super(UserListState(langUI: langUI, langArticles: langArticles));

  final UserService _service;

  bool get isFirstFetch => state.page == 1;
  bool get isLastPage => state.page >= state.pagesCount;

  void fetchAll() async {
    if (state.status == UserListStatus.loading || !isFirstFetch && isLastPage) {
      return;
    }

    emit(state.copyWith(status: UserListStatus.loading));

    try {
      var response = await _service.fetchAll(
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
    } on DisplayableException catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        status: UserListStatus.failure,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Не удалось получить пользователей',
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
