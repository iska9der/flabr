import 'dart:async';

import 'package:equatable/equatable.dart';

import '../../../../../data/exception/part.dart';
import '../../../../../data/model/filter/part.dart';
import '../../../../../data/model/list_response/list_response_model.dart';
import '../../../../../data/model/publication/publication.dart';
import '../../../../../data/model/publication/publication_type_enum.dart';
import '../../../../feature/publication_list/part.dart';

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

  @override
  Future<void> fetch() async {
    if (fetchDisabled) {
      return;
    }

    emit(state.copyWith(status: PublicationListStatus.loading));

    try {
      ListResponse response = await repository.fetchHubArticles(
        langUI: languageRepository.ui,
        langArticles: languageRepository.articles,
        hub: state.hub,
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

  void applyFilter(FlowFilter filter) {
    emit(HubPublicationListState(
      hub: state.hub,
      type: state.type,
      filter: filter,
    ));
  }
}
