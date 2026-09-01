import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/loading_status_enum.dart';
import '../../data/model/user/user.dart';
import '../../data/repository/repository.dart';
import '../error/app_failure.dart';

part 'user_list_state.dart';

class UserListCubit extends Cubit<UserListState> {
  UserListCubit({required this._repository}) : super(const UserListState());

  final UserRepository _repository;

  bool get isFirstFetch => state.page == 1;
  bool get isLastPage => state.page >= state.pagesCount;

  void fetchAll() async {
    if (state.status == .loading || !isFirstFetch && isLastPage) {
      return;
    }

    emit(state.copyWith(status: .loading));

    try {
      var response = await _repository.fetchAll(page: state.page.toString());

      emit(
        state.copyWith(
          status: .success,
          users: [...state.users, ...response.refs],
          page: state.page + 1,
          pagesCount: response.pagesCount,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          error: AppFailure(.userListFetchFailed, e),
          status: .failure,
        ),
      );
    }
  }
}
