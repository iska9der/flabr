import 'dart:async';

import 'package:equatable/equatable.dart';

import '../../../../data/exception/part.dart';
import '../../../../data/model/filter/part.dart';
import '../../../../data/model/list_response/list_response.dart';
import '../../../../data/model/publication/publication.dart';
import '../../../../data/model/publication/publication_flow_enum.dart';
import '../../../../data/model/publication/publication_type_enum.dart';
import '../../../feature/publication_list/part.dart';

part 'flow_publication_list_state.dart';

class FlowPublicationListCubit
    extends PublicationListCubit<FlowPublicationListState> {
  FlowPublicationListCubit({
    required super.repository,
    required super.languageRepository,
    PublicationFlow flow = PublicationFlow.all,
    PublicationType type = PublicationType.article,
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
    if (state.sort == sort) return;

    emit(FlowPublicationListState(
      flow: state.flow,
      type: state.type,
      sort: sort,
    ));
  }

  void changeSortByOption(Sort sort, FilterOption option) {
    FlowPublicationListState newState;
    switch (sort) {
      case Sort.byBest:
        if (state.period == option) return;
        newState = FlowPublicationListState(period: option);
      case Sort.byNew:
        if (state.score == option) return;
        newState = FlowPublicationListState(score: option);
      default:
        throw ValueException('Неизвестный вариант сортировки статей');
    }

    emit(newState.copyWith(
      flow: state.flow,
      type: state.type,
      sort: sort,
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
        sort: state.sort,
        period: state.period,
        score: state.score,
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
