import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/exception/displayable_exception.dart';
import '../../../component/localization/language_enum.dart';
import '../model/user_model.dart';
import '../service/users_service.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit(
    UsersService service, {
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
  })  : _service = service,
        super(UsersState(langUI: langUI, langArticles: langArticles));

  final UsersService _service;

  bool get isFirstFetch => state.page == 1;
  bool get isLastPage => state.page >= state.pagesCount;

  void fetchAll() async {
    if (state.status == UsersStatus.loading || !isFirstFetch && isLastPage) {
      return;
    }

    emit(state.copyWith(status: UsersStatus.loading));

    try {
      var response = await _service.fetchAll(
        langUI: state.langUI,
        langArticles: state.langArticles,
        page: state.page.toString(),
      );

      emit(state.copyWith(
        status: UsersStatus.success,
        users: [...state.users, ...response.models],
        page: state.page + 1,
        pagesCount: response.pagesCount,
      ));
    } on DisplayableException catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        status: UsersStatus.failure,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Не удалось получить пользователей',
        status: UsersStatus.failure,
      ));
    }
  }

  changeLanguages({
    LanguageEnum? langUI,
    List<LanguageEnum>? langArticles,
  }) {
    emit(UsersState(
      langUI: langUI ?? state.langUI,
      langArticles: langArticles ?? state.langArticles,
    ));
  }
}
