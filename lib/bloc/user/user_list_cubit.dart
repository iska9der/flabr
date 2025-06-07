import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/exception/exception.dart';
import '../../data/model/user/user.dart';
import '../../data/repository/repository.dart';

part 'user_list_state.dart';

class UserListCubit extends Cubit<UserListState> {
  UserListCubit({required UserRepository repository})
    : _repository = repository,
      super(const UserListState());

  final UserRepository _repository;

  bool get isFirstFetch => state.page == 1;
  bool get isLastPage => state.page >= state.pagesCount;

  void fetchAll() async {
    if (state.status == UserListStatus.loading || !isFirstFetch && isLastPage) {
      return;
    }

    emit(state.copyWith(status: UserListStatus.loading));

    try {
      var response = await _repository.fetchAll(page: state.page.toString());

      emit(
        state.copyWith(
          status: UserListStatus.success,
          users: [...state.users, ...response.refs],
          page: state.page + 1,
          pagesCount: response.pagesCount,
        ),
      );
    } catch (e) {
      const fallbackMessage = 'Не удалось получить пользователей';

      emit(
        state.copyWith(
          error: e.parseException(fallbackMessage),
          status: UserListStatus.failure,
        ),
      );
    }
  }
}
