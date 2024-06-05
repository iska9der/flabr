import 'dart:async';

import 'package:equatable/equatable.dart';

import '../../../../data/exception/part.dart';
import '../../../../data/model/filter/part.dart';
import '../../../../data/model/list_response/list_response.dart';
import '../../../../data/model/publication/publication.dart';
import '../../../../data/model/publication/publication_flow_enum.dart';
import '../../../feature/publication_list/part.dart';

part 'flow_publication_list_state.dart';

class FlowPublicationListCubit
    extends PublicationListCubit<FlowPublicationListState> {
  FlowPublicationListCubit({
    required super.repository,
    required super.languageRepository,
    PublicationFlow flow = PublicationFlow.all,
    FlowFilterPublication type = FlowFilterPublication.article,
  }) : super(FlowPublicationListState(
          flow: flow,
          type: type,
        ));

  void changeFlow(PublicationFlow value) {
    if (state.flow == value) return;

    emit(FlowPublicationListState(
      flow: value,
      type: state.type,
    ));
  }

  void changeSortBy(Sort sort) {
    if (state.filter.sort == sort) return;

    emit(FlowPublicationListState(
      flow: state.flow,
      type: state.type,
      filter: state.filter.copyWith(sort: sort),
    ));
  }

  void changeSortByOption(Sort sort, FilterOption option) {
    final FlowFilter newFilter;

    switch (sort) {
      case Sort.byBest:
        if (state.filter.period == option) return;
        newFilter = state.filter.copyWith(period: option);
      case Sort.byNew:
        if (state.filter.score == option) return;
        newFilter = state.filter.copyWith(score: option);
    }

    emit(FlowPublicationListState(
      flow: state.flow,
      type: state.type,
      filter: newFilter,
    ));
  }

  @override
  Future<void> fetch() async {
    if (state.status == PublicationListStatus.loading ||
        !isFirstFetch && isLastPage) {
      return;
    }

    emit(state.copyWith(status: PublicationListStatus.loading));

    try {
      ListResponse response = await repository.fetchFlowArticles(
        langUI: languageRepository.ui,
        langArticles: languageRepository.articles,
        type: state.type,
        flow: state.flow,
        filter: state.filter,
        page: state.page.toString(),
      );

      emit(state.copyWith(
        status: PublicationListStatus.success,
        publications: [...state.publications, ...response.refs],
        page: state.page + 1,
        pagesCount: response.pagesCount,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: ExceptionHelper.parseMessage(e, 'Не удалось получить статьи'),
        status: PublicationListStatus.failure,
      ));

      rethrow;
    }
  }

  @override
  void refetch() {
    emit(state.copyWith(
      status: PublicationListStatus.initial,
      page: 1,
      publications: [],
      pagesCount: 0,
    ));
  }
}
