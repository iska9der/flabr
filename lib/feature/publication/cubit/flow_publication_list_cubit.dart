import 'dart:async';

import 'package:equatable/equatable.dart';

import '../../../common/exception/exception_helper.dart';
import '../../../common/exception/value_exception.dart';
import '../../../common/model/network/list_response.dart';
import '../model/flow_enum.dart';
import '../model/publication/publication.dart';
import '../model/publication_type.dart';
import '../model/sort/date_period_enum.dart';
import '../model/sort/sort_enum.dart';
import '../model/sort/sort_option_model.dart';
import 'publication_list_cubit.dart';

part 'flow_publication_list_state.dart';

class FlowPublicationListCubit
    extends PublicationListCubit<FlowPublicationListState> {
  FlowPublicationListCubit({
    required super.repository,
    required super.languageRepository,
    FlowEnum flow = FlowEnum.all,
    PublicationType type = PublicationType.article,
  }) : super(FlowPublicationListState(
          flow: flow,
          type: type,
        ));

  void changeFlow(FlowEnum value) {
    if (state.flow == value) return;

    emit(FlowPublicationListState(
      flow: value,
      type: state.type,
    ));
  }

  void changeSort(SortEnum sort) {
    if (state.sort == sort) return;

    emit(FlowPublicationListState(
      flow: state.flow,
      type: state.type,
      sort: sort,
    ));
  }

  void changeSortOption(SortEnum sort, SortOptionModel option) {
    FlowPublicationListState newState;
    switch (sort) {
      case SortEnum.byBest:
        if (state.period == option.value) return;
        newState = FlowPublicationListState(period: option.value);
      case SortEnum.byNew:
        if (state.score == option.value) return;
        newState = FlowPublicationListState(score: option.value);
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
