import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/exception/exception.dart';
import '../../../../../data/model/list_response_model.dart';
import '../../../../../data/model/search/search_order_enum.dart';
import '../../../../../data/model/search/search_target_enum.dart';
import '../../../../../data/repository/repository.dart';
import '../../../../extension/extension.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    required SearchRepository repository,
    required LanguageRepository langRepository,
    SearchTarget target = SearchTarget.posts,
    SearchOrder order = SearchOrder.relevance,
  }) : _repository = repository,
       _langRepository = langRepository,
       super(SearchState(target: target, order: order));

  final SearchRepository _repository;
  final LanguageRepository _langRepository;

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
    if (state.query == newQuery || state.status.isLoading) return;

    emit(
      state.copyWith(
        query: newQuery,
        page: 1,
        listResponse: ListResponse.empty,
      ),
    );

    await fetch();
  }

  Future<void> fetch() async {
    if (state.status.isLoading || !state.isFirstFetch && state.isLastPage) {
      return;
    }

    emit(state.copyWith(status: SearchStatus.loading));

    try {
      final list = await _repository.fetch(
        langUI: _langRepository.ui,
        langArticles: _langRepository.articles,
        query: state.query,
        target: state.target,
        order: state.order,
        page: state.page,
      );

      var newList = state.listResponse.copyWith(
        pagesCount: list.pagesCount,
        ids: [...state.listResponse.ids, ...list.ids],
        refs: [...state.listResponse.refs, ...list.refs],
      );

      emit(
        state.copyWith(
          status: SearchStatus.success,
          listResponse: newList,
          page: state.page + 1,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: SearchStatus.failure, error: e.parseException()),
      );
    }
  }

  void reset() {
    emit(const SearchState());
  }
}
