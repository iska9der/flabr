import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/hub/hub.dart';
import '../../data/model/list_response_model.dart';
import '../../data/model/loading_status_enum.dart';
import '../../data/repository/repository.dart';
import '../error/app_failure.dart';

part 'hub_list_state.dart';

class HubListCubit extends Cubit<HubListState> {
  HubListCubit({
    required this._repository,
    required this._settingsRepository,
  }) : super(const HubListState());

  final HubRepository _repository;
  final SettingsRepository _settingsRepository;

  void fetch() async {
    if (state.status == .loading || state.isLastPage) {
      return;
    }

    emit(state.copyWith(status: .loading));

    try {
      final response = await _repository.fetchAll(page: state.page);
      final paginationEnabled =
          _settingsRepository.lastConfig.feed.navigationMode == .pagination;
      final list = paginationEnabled
          ? response
          : state.list.merge(response, getId: (ref) => ref.alias);

      emit(
        state.copyWith(
          status: .success,
          list: list,
          page: state.page + 1,
        ),
      );
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: .failure,
          error: AppFailure(.hubListFetchFailed, error),
        ),
      );

      super.onError(error, stackTrace);
    }
  }

  /// Переводит Cubit в пустое состояние указанной страницы
  void reset({int page = 1}) => emit(HubListState(page: page));

  /// Загружает выбранную страницу без элементов с других страниц
  void changePage(int page) {
    final pagesCount = state.list.pagesCount;
    final isOutOfRange = page < 1 || pagesCount > 0 && page > pagesCount;

    if (state.status == .loading || isOutOfRange || page == state.currentPage) {
      return;
    }

    reset(page: page);
  }
}
