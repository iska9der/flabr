import 'dart:async';

import 'package:equatable/equatable.dart';

import '../../../common/cubit/publication_list.dart';
import '../../../common/exception/exception_helper.dart';
import '../../../common/exception/value_exception.dart';
import '../../../common/model/network/list_response.dart';
import '../../settings/repository/language_repository.dart';
import '../model/flow_enum.dart';
import '../model/network/publication_list_response.dart';
import '../model/publication/publication.dart';
import '../model/publication_type.dart';
import '../model/sort/date_period_enum.dart';
import '../model/sort/sort_enum.dart';
import '../model/sort/sort_option_model.dart';
import '../model/source/publication_list_source.dart';
import '../repository/publication_repository.dart';

part 'publication_list_state.dart';

class PublicationListCubit extends PublicationListC<PublicationListState> {
  /// [source] - откуда поступает запрос на получение списка публикаций.
  /// От этого параметра зависит какой метод получения публикации будет вызван.
  PublicationListCubit({
    required PublicationRepository repository,
    required LanguageRepository languageRepository,
    PublicationListSource source = PublicationListSource.flow,
    FlowEnum flow = FlowEnum.all,
    String hub = '',
    String user = '',
    PublicationType type = PublicationType.article,
  })  : _repository = repository,
        _languageRepository = languageRepository,
        super(
          PublicationListState(
            source: source,
            flow: flow,
            hub: hub,
            user: user,
            type: type,
          ),
        ) {
    _uiLangSub = _languageRepository.uiStream.listen(
      (_) => refetch(),
    );
    _articleLangsSub = _languageRepository.articlesStream.listen(
      (_) => refetch(),
    );
  }

  final PublicationRepository _repository;
  final LanguageRepository _languageRepository;

  late final StreamSubscription _uiLangSub;
  late final StreamSubscription _articleLangsSub;

  @override
  Future<void> close() {
    _uiLangSub.cancel();
    _articleLangsSub.cancel();

    return super.close();
  }

  void changeFlow(FlowEnum value) {
    if (state.flow == value) return;

    emit(PublicationListState(
      source: state.source,
      flow: value,
      hub: state.hub,
      user: state.user,
      type: state.type,
    ));
  }

  void changeSort(SortEnum value) {
    if (state.sort == value) return;

    emit(PublicationListState(
      source: state.source,
      flow: state.flow,
      hub: state.hub,
      user: state.user,
      type: state.type,
      sort: value,
    ));
  }

  void changeSortOption(SortEnum sort, SortOptionModel option) {
    PublicationListState newState;
    switch (sort) {
      case SortEnum.byBest:
        if (state.period == option.value) return;
        newState = PublicationListState(period: option.value);
      case SortEnum.byNew:
        if (state.score == option.value) return;
        newState = PublicationListState(score: option.value);
      default:
        throw ValueException('Неизвестный вариант сортировки статей');
    }

    emit(newState.copyWith(
      source: state.source,
      flow: state.flow,
      hub: state.hub,
      user: state.user,
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
      ListResponse response = switch (state.source) {
        PublicationListSource.flow => await _fetchFlowArticles(),
        PublicationListSource.userBookmarks => await _fetchUserBookmarks()
      };

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

  Future<ListResponse> _fetchFlowArticles() async {
    return await _repository.fetchFlowArticles(
      langUI: _languageRepository.ui,
      langArticles: _languageRepository.articles,
      type: state.type,
      flow: state.flow,
      sort: state.sort,
      period: state.period,
      score: state.score,
      page: state.page.toString(),
    );
  }

  Future<PublicationListResponse> _fetchUserBookmarks() async {
    return await _repository.fetchUserBookmarks(
      langUI: _languageRepository.ui,
      langArticles: _languageRepository.articles,
      user: state.user,
      page: state.page.toString(),
    );
  }

  void refetch() {
    emit(state.copyWith(
      status: PublicationListStatus.initial,
      page: 1,
      publications: [],
      pagesCount: 0,
    ));
  }
}
