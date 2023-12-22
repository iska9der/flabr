import 'dart:async';

import 'package:equatable/equatable.dart';

import '../../../common/cubit/publication_list.dart';
import '../../../common/exception/exception_helper.dart';
import '../../../common/model/network/list_response.dart';
import '../../publication/model/publication/publication.dart';
import '../../publication/model/publication_type.dart';
import '../../publication/model/sort/date_period_enum.dart';
import '../../publication/model/sort/sort_enum.dart';
import '../../publication/repository/publication_repository.dart';
import '../../settings/repository/language_repository.dart';

part 'hub_publication_list_state.dart';

class HubPublicationListCubit
    extends PublicationListC<HubPublicationListState> {
  HubPublicationListCubit({
    required PublicationRepository repository,
    required LanguageRepository languageRepository,
    String hub = '',
    PublicationType type = PublicationType.article,
  })  : _repository = repository,
        _languageRepository = languageRepository,
        super(HubPublicationListState(
          hub: hub,
          type: type,
        ));

  final PublicationRepository _repository;
  final LanguageRepository _languageRepository;

  void refetch() {
    emit(state.copyWith(
      status: PublicationListStatus.initial,
      page: 1,
      publications: [],
      pagesCount: 0,
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
      ListResponse response = await _repository.fetchHubArticles(
        langUI: _languageRepository.ui,
        langArticles: _languageRepository.articles,
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
}
