import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/exception/exception.dart';
import '../../data/model/loading_status_enum.dart';
import '../../data/model/user/user.dart';
import '../../data/repository/repository.dart';

part 'user_list_state.dart';

class UserListCubit extends Cubit<UserListState> {
  UserListCubit({required UserRepository repository})
    : _repository = repository,
      super(const UserListState());

  final UserRepository _repository;

  int get page => state.page;
  bool get isFirstFetch => page == 1;
  bool get isLastPage => page >= state.pagesCount;

  void fetchAll() async {
    if (state.status == .loading || !isFirstFetch && isLastPage) {
      return;
    }

    emit(state.copyWith(status: .loading));

    try {
      var response = await _repository.fetchAll(page: page.toString());

      emit(
        state.copyWith(
          status: .success,
          users: [...state.users, ...response.refs],
          page: page + 1,
          pagesCount: response.pagesCount,
        ),
      );
    } catch (e) {
      const fallbackMessage = 'Не удалось получить пользователей';

      emit(
        state.copyWith(
          status: .failure,
          error: e.parseException(fallbackMessage),
        ),
      );
    }
  }
}
