import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/loading_status_enum.dart';
import '../../data/model/user/user.dart';
import '../../data/repository/repository.dart';
import '../error/app_failure.dart';

part 'user_list_state.dart';

class UserListCubit extends Cubit<UserListState> {
  UserListCubit({
    required this._repository,
    required this._settingsRepository,
  }) : super(const UserListState());

  final UserRepository _repository;
  final SettingsRepository _settingsRepository;

  void fetchAll() async {
    if (state.status == .loading || state.isLastPage) {
      return;
    }

    emit(state.copyWith(status: .loading));

    try {
      final response = await _repository.fetchAll(page: state.page.toString());
      final paginationEnabled =
          _settingsRepository.lastConfig.feed.navigationMode == .pagination;

      emit(
        state.copyWith(
          status: .success,
          users: paginationEnabled
              ? response.refs
              : [...state.users, ...response.refs],
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

  /// Переводит Cubit в пустое состояние указанной страницы
  void reset({int page = 1}) => emit(UserListState(page: page));

  /// Загружает выбранную страницу без элементов с других страниц
  void changePage(int page) {
    final isOutOfRange =
        page < 1 || state.pagesCount > 0 && page > state.pagesCount;

    if (state.status == .loading || isOutOfRange || page == state.currentPage) {
      return;
    }

    reset(page: page);
  }
}
