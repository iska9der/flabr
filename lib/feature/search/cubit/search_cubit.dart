import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/exception/displayable_exception.dart';
import '../../../common/model/extension/state_status_x.dart';
import '../../../common/model/network/list_response.dart';
import '../../../component/localization/language_enum.dart';
import '../model/search_order.dart';
import '../model/search_target.dart';
import '../service/search_service.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(
    SearchService service, {
    SearchTarget target = SearchTarget.posts,
    SearchOrder order = SearchOrder.relevance,
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
  })  : _service = service,
        super(SearchState(
          langUI: langUI,
          langArticles: langArticles,
          target: target,
          order: order,
        ));

  final SearchService _service;

  Future<void> changeTarget(SearchTarget newTarget) async {
    if (state.target == newTarget) return;

    emit(state.copyWith(target: newTarget, page: 1));

    /// если запрос введен и пользователь нажимает на чип,
    /// то повторно выполняем запрос с новым таргетом
    if (state.query.isNotEmpty) {
      emit(state.copyWith(listResponse: const ListResponse()));

      await fetch();
    }
  }

  Future<void> changeSort(SearchOrder newOrder) async {
    if (state.order == newOrder) return;

    emit(state.copyWith(order: newOrder, page: 1));

    /// если запрос введен и пользователь нажимает на чип,
    /// то повторно выполняем запрос с новым таргетом
    if (state.query.isNotEmpty) {
      emit(state.copyWith(listResponse: const ListResponse()));

      await fetch();
    }
  }

  Future<void> changeQuery(String newQuery) async {
    if (state.query == newQuery || state.status.isLoading) return;

    emit(state.copyWith(
      query: newQuery,
      page: 1,
      listResponse: const ListResponse(),
    ));

    await fetch();
  }

  Future<void> fetch() async {
    if (state.status.isLoading || !state.isFirstFetch && state.isLastPage) {
      return;
    }

    emit(state.copyWith(status: SearchStatus.loading));
    try {
      ListResponse list = await _service.fetch(
        langUI: state.langUI,
        langArticles: state.langArticles,
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

      emit(state.copyWith(
        status: SearchStatus.success,
        listResponse: newList,
        page: state.page + 1,
      ));
    } on DisplayableException catch (e) {
      emit(state.copyWith(status: SearchStatus.failure, error: e.toString()));
    }
  }

  void reset() {
    emit(const SearchState());
  }
}