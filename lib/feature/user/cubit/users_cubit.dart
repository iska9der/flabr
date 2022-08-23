import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../common/exception/displayable_exception.dart';
import '../model/user_model.dart';
import '../service/users_service.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit(UsersService service)
      : _service = service,
        super(const UsersState());

  final UsersService _service;

  bool get isFirstFetch => state.page == 1;
  bool get isLastPage => state.page >= state.pagesCount;

  void fetchAll() async {
    if (state.status == UsersStatus.loading || !isFirstFetch && isLastPage) {
      return;
    }

    emit(state.copyWith(status: UsersStatus.loading));

    try {
      var response = await _service.fetchAll(page: state.page.toString());

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
}
