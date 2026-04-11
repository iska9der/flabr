import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/exception/exception.dart';
import '../../data/model/list_response_model.dart';
import '../../data/model/loading_status_enum.dart';
import '../../data/model/search/search_order_enum.dart';
import '../../data/model/search/search_target_enum.dart';
import '../../data/repository/repository.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    required SearchRepository repository,
    SearchTarget target = SearchTarget.posts,
    SearchOrder order = SearchOrder.relevance,
  }) : _repository = repository,
       super(SearchState(target: target, order: order));

  final SearchRepository _repository;

  Future<void> changeTarget(SearchTarget newTarget) async {
    if (state.target == newTarget) return;

    emit(state.copyWith(target: newTarget, page: 1));

    /// если запрос введен и пользователь нажимает на чип,
    /// то повторно выполняем запрос с новым таргетом
    if (state.query.isNotEmpty) {
      emit(state.copyWith(listResponse: ListResponse.empty));

      await fetch();
    }
  }

  Future<void> changeSort(SearchOrder newOrder) async {
    if (state.order == newOrder) return;

    emit(state.copyWith(order: newOrder, page: 1));

    /// если запрос введен и пользователь нажимает на чип,
    /// то повторно выполняем запрос с новым таргетом
    if (state.query.isNotEmpty) {
      emit(state.copyWith(listResponse: ListResponse.empty));

      await fetch();
    }
  }

  Future<void> changeQuery(String newQuery) async {
    if (state.query == newQuery && state.status != .failure ||
        state.status == .loading) {
      return;
    }

    emit(state.copyWith(query: newQuery, page: 1, listResponse: .empty));

    await fetch();
  }

  Future<void> fetch() async {
    if (state.status == .loading || !state.isFirstFetch && state.isLastPage) {
      return;
    }

    emit(state.copyWith(status: .loading));

    try {
      final response = await _repository.fetch(
        query: state.query,
        target: state.target,
        order: state.order,
        page: state.page,
      );

      emit(
        state.copyWith(
          status: .success,
          page: state.page + 1,
          listResponse: state.listResponse.merge(response),
        ),
      );
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: .failure,
          error: error.parseException(),
        ),
      );

      super.onError(error, stackTrace);
    }
  }

  void reset() {
    emit(const SearchState());
  }
}
