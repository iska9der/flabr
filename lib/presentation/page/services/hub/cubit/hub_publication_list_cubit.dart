import 'dart:async';

import 'package:equatable/equatable.dart';

import '../../../../../data/exception/part.dart';
import '../../../../../data/model/list_response/list_response.dart';
import '../../../../../data/model/publication/publication.dart';
import '../../../../../data/model/publication/publication_type_enum.dart';
import '../../../../../data/model/sort/sort_date_period_enum.dart';
import '../../../../../data/model/sort/sort_enum.dart';
import '../../../../cubit/publication_list_cubit.dart';

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

  void changeSortBy(Sort sort) {
    if (state.sort == sort) return;

    emit(HubPublicationListState(
      hub: state.hub,
      type: state.type,
      sort: sort,
    ));
  }

  void changeSortByOption(Sort sort, dynamic value) {
    HubPublicationListState newState;
    switch (sort) {
      case Sort.byBest:
        if (state.period == value) return;
        newState = HubPublicationListState(period: value);
      case Sort.byNew:
        if (state.score == value) return;
        newState = HubPublicationListState(score: value);
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
