import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/exception/exception_helper.dart';
import '../../../common/exception/value_exception.dart';
import '../../settings/repository/language_repository.dart';
import '../model/article_from_enum.dart';
import '../model/article_model.dart';
import '../model/article_type.dart';
import '../model/flow_enum.dart';
import '../model/network/article_list_response.dart';
import '../model/sort/date_period_enum.dart';
import '../model/sort/sort_enum.dart';
import '../model/sort/sort_option_model.dart';
import '../repository/article_repository.dart';

part 'article_list_state.dart';

class ArticleListCubit extends Cubit<ArticleListState> {
  ArticleListCubit({
    required ArticleRepository repository,
    required LanguageRepository languageRepository,
    from = ArticleFromEnum.flow,
    flow = FlowEnum.all,
    hub = '',
    user = '',
    type = ArticleType.article,
  })  : _repository = repository,
        _languageRepository = languageRepository,
        super(
          ArticleListState(
            from: from,
            flow: flow,
            hub: hub,
            user: user,
            type: type,
          ),
        ) {
    if (from == ArticleFromEnum.hub) {
      assert(state.hub.isNotEmpty, 'Нужно указать хаб [hub]');
    }
    if (from == ArticleFromEnum.userArticles) {
      assert(state.user.isNotEmpty, 'Нужно указать пользователя [user]');
    }

    _uiLangSub = _languageRepository.uiStream.listen(
      (_) => refetch(),
    );
    _articleLangsSub = _languageRepository.articlesStream.listen(
      (_) => refetch(),
    );
  }

  final ArticleRepository _repository;
  final LanguageRepository _languageRepository;

  late final StreamSubscription _uiLangSub;
  late final StreamSubscription _articleLangsSub;

  @override
  Future<void> close() {
    _uiLangSub.cancel();
    _articleLangsSub.cancel();

    return super.close();
  }

  bool get isFirstFetch => state.page == 1;
  bool get isLastPage => state.page >= state.pagesCount;

  void changeFlow(FlowEnum value) {
    if (state.flow == value) return;

    emit(ArticleListState(
      from: state.from,
      flow: value,
      hub: state.hub,
      user: state.user,
      type: state.type,
    ));
  }

  void changeSort(SortEnum value) {
    if (state.sort == value) return;

    emit(ArticleListState(
      from: state.from,
      flow: state.flow,
      hub: state.hub,
      user: state.user,
      type: state.type,
      sort: value,
    ));
  }

  void changeSortOption(SortEnum sort, SortOptionModel option) {
    ArticleListState newState;
    switch (sort) {
      case SortEnum.byBest:
        if (state.period == option.value) return;
        newState = ArticleListState(period: option.value);
      case SortEnum.byNew:
        if (state.score == option.value) return;
        newState = ArticleListState(score: option.value);
      default:
        throw ValueException('Неизвестный вариант сортировки статей');
    }

    emit(newState.copyWith(
      from: state.from,
      flow: state.flow,
      hub: state.hub,
      user: state.user,
      type: state.type,
      sort: sort,
    ));
  }

  /// FETCH ARTICLES
  void fetch() async {
    if (state.status == ArticleListStatus.loading ||
        !isFirstFetch && isLastPage) {
      return;
    }

    emit(state.copyWith(status: ArticleListStatus.loading));

    try {
      ArticleListResponse response = switch (state.from) {
        ArticleFromEnum.flow => await _fetchFlowArticles(),
        ArticleFromEnum.hub => await _fetchHubArticles(),
        ArticleFromEnum.userArticles => await _fetchUserArticles(),
        ArticleFromEnum.userBookmarks => await _fetchUserBookmarks()
      };

      emit(state.copyWith(
        status: ArticleListStatus.success,
        articles: [...state.articles, ...response.refs],
        page: state.page + 1,
        pagesCount: response.pagesCount,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: ExceptionHelper.parseMessage(e, 'Не удалось получить статьи'),
        status: ArticleListStatus.failure,
      ));
    }
  }

  Future<ArticleListResponse> _fetchFlowArticles() async {
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

  Future<ArticleListResponse> _fetchHubArticles() async {
    return await _repository.fetchHubArticles(
      langUI: _languageRepository.ui,
      langArticles: _languageRepository.articles,
      hub: state.hub,
      sort: state.sort,
      period: state.period,
      score: state.score,
      page: state.page.toString(),
    );
  }

  Future<ArticleListResponse> _fetchUserArticles() async {
    return await _repository.fetchUserArticles(
      langUI: _languageRepository.ui,
      langArticles: _languageRepository.articles,
      user: state.user,
      sort: state.sort,
      period: state.period,
      score: state.score,
      page: state.page.toString(),
    );
  }

  Future<ArticleListResponse> _fetchUserBookmarks() async {
    return await _repository.fetchUserBookmarks(
      langUI: _languageRepository.ui,
      langArticles: _languageRepository.articles,
      user: state.user,
      page: state.page.toString(),
    );
  }

  void refetch() {
    emit(state.copyWith(
      status: ArticleListStatus.initial,
      page: 1,
      articles: [],
      pagesCount: 0,
    ));
  }
}
