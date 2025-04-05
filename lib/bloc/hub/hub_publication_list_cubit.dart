import 'dart:async';

import 'package:equatable/equatable.dart';

import '../../data/exception/exception.dart';
import '../../data/model/filter/filter.dart';
import '../../data/model/publication/publication.dart';
import '../../feature/publication_list/publication_list.dart';

part 'hub_publication_list_state.dart';

class HubPublicationListCubit
    extends PublicationListCubit<HubPublicationListState> {
  HubPublicationListCubit({
    required super.repository,
    required super.languageRepository,
    String hub = '',
    PublicationType type = PublicationType.article,
  }) : super(HubPublicationListState(hub: hub, type: type));

  @override
  Future<void> fetch() async {
    if (fetchDisabled) {
      return;
    }

    emit(state.copyWith(status: PublicationListStatus.loading));

    try {
      final response = await repository.fetchHubArticles(
        langUI: languageRepository.ui,
        langArticles: languageRepository.articles,
        hub: state.hub,
        filter: state.filter,
        page: state.page.toString(),
      );

      emit(
        state.copyWith(
          status: PublicationListStatus.success,
          publications: [...state.publications, ...response.refs],
          page: state.page + 1,
          pagesCount: response.pagesCount,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          error: e.parseException('Не удалось получить статьи'),
          status: PublicationListStatus.failure,
        ),
      );

      rethrow;
    }
  }

  @override
  void refetch() {
    emit(
      state.copyWith(
        status: PublicationListStatus.initial,
        page: 1,
        publications: [],
        pagesCount: 0,
      ),
    );
  }

  void applyFilter(FlowFilter filter) {
    emit(
      HubPublicationListState(hub: state.hub, type: state.type, filter: filter),
    );
  }
}
