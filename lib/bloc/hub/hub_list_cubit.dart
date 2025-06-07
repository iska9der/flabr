import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/exception/exception.dart';
import '../../data/model/hub/hub.dart';
import '../../data/model/list_response_model.dart';
import '../../data/repository/repository.dart';

part 'hub_list_state.dart';

class HubListCubit extends Cubit<HubListState> {
  HubListCubit({required HubRepository repository})
    : _repository = repository,
      super(const HubListState());

  final HubRepository _repository;

  void fetch() async {
    if (state.status == HubListStatus.loading ||
        !state.isFirstFetch && state.isLastPage) {
      return;
    }

    emit(state.copyWith(status: HubListStatus.loading));

    try {
      final response = await _repository.fetchAll(page: state.page);

      var newList = state.list.copyWith(
        ids: [...state.list.ids, ...response.ids],
        pagesCount: response.pagesCount,
        refs: [...state.list.refs, ...response.refs],
      );

      emit(
        state.copyWith(
          status: HubListStatus.success,
          list: newList,
          page: state.page + 1,
        ),
      );
    } catch (error, stackTrace) {
      const fallbackMessage = 'Не удалось получить список хабов';
      emit(
        state.copyWith(
          status: HubListStatus.failure,
          error: error.parseException(fallbackMessage),
        ),
      );

      super.onError(error, stackTrace);
    }
  }
}
