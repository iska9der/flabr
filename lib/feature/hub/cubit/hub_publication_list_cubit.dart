import 'dart:async';

import 'package:equatable/equatable.dart';

import '../../../common/exception/exception_helper.dart';
import '../../../common/exception/value_exception.dart';
import '../../../common/model/network/list_response.dart';
import '../../publication/cubit/publication_list_cubit.dart';
import '../../publication/model/publication/publication.dart';
import '../../publication/model/publication_type.dart';
import '../../publication/model/sort/date_period_enum.dart';
import '../../publication/model/sort/sort_enum.dart';
import '../../publication/model/sort/sort_option_model.dart';

part 'hub_publication_list_state.dart';

class HubPublicationListCubit
    extends PublicationListCubit<HubPublicationListState> {
  HubPublicationListCubit({
    required super.repository,
    required super.languageRepository,
    String hub = '',
    PublicationType type = PublicationType.article,
  }) : super(HubPublicationListState(
          hub: hub,
          type: type,
        ));

  void changeSort(SortEnum sort) {
    if (state.sort == sort) return;

    emit(HubPublicationListState(
      hub: state.hub,
      type: state.type,
      sort: sort,
    ));
  }

  void changeSortOption(SortEnum sort, SortOptionModel option) {
    HubPublicationListState newState;
    switch (sort) {
      case SortEnum.byBest:
        if (state.period == option.value) return;
        newState = HubPublicationListState(period: option.value);
      case SortEnum.byNew:
        if (state.score == option.value) return;
        newState = HubPublicationListState(score: option.value);
      default:
        throw ValueException('Неизвестный вариант сортировки статей');
    }

    emit(newState.copyWith(
      hub: state.hub,
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
      ListResponse response = await repository.fetchHubArticles(
        langUI: languageRepository.ui,
        langArticles: languageRepository.articles,
        hub: state.hub,
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
