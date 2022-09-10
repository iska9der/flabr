import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/exception/displayable_exception.dart';
import '../../../common/exception/value_exception.dart';
import '../../../component/localization/language_enum.dart';
import '../model/article_from_enum.dart';
import '../model/article_model.dart';
import '../model/article_type.dart';
import '../model/flow_enum.dart';
import '../model/sort/date_period_enum.dart';
import '../model/sort/sort_enum.dart';
import '../model/sort/sort_option_model.dart';
import '../service/article_service.dart';

part 'article_list_state.dart';

class ArticleListCubit extends Cubit<ArticleListState> {
  ArticleListCubit(
    ArticleService service, {
    from = ArticleFromEnum.flow,
    flow = FlowEnum.all,
    hub = '',
    user = '',
    type = ArticleType.article,
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
  })  : _service = service,
        super(
          ArticleListState(
            from: from,
            flow: flow,
            hub: hub,
            user: user,
            type: type,
            langUI: langUI,
            langArticles: langArticles,
          ),
        ) {
    if (from == ArticleFromEnum.hub) {
      assert(state.hub.isNotEmpty, 'Нужно указать хаб [hub]');
    }
    if (from == ArticleFromEnum.user) {
      assert(state.user.isNotEmpty, 'Нужно указать пользователя [user]');
    }
  }

  final ArticleService _service;

  bool get isFirstFetch => state.page == 1;

  bool get isLastPage => state.page >= state.pagesCount;

  void changeFlow(FlowEnum value, {String connectSid = ''}) {
    if (state.flow == value) return;

    emit(ArticleListState(
      from: state.from,
      flow: value,
      connectSid: connectSid,
      hub: state.hub,
      user: state.user,
      langUI: state.langUI,
      langArticles: state.langArticles,
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
      langUI: state.langUI,
      langArticles: state.langArticles,
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
        break;
      case SortEnum.byNew:
        if (state.score == option.value) return;

        newState = ArticleListState(score: option.value);
        break;
      default:
        throw ValueException('Неизвестный вариант сортировки статей');
    }

    emit(newState.copyWith(
      from: state.from,
      flow: state.flow,
      hub: state.hub,
      user: state.user,
      langUI: state.langUI,
      langArticles: state.langArticles,
      type: state.type,
      sort: sort,
    ));
  }

  void changeLanguage({
    LanguageEnum? langUI,
    List<LanguageEnum>? langArticles,
  }) {
    emit(ArticleListState(
      from: state.from,
      flow: state.flow,
      hub: state.hub,
      user: state.user,
      langUI: langUI ?? state.langUI,
      langArticles: langArticles ?? state.langArticles,
      type: state.type,
    ));
  }

  /// FETCH ARTICLES
  ///
  ///
  void fetch() async {
    if (state.status == ArticlesStatus.loading || !isFirstFetch && isLastPage) {
      return;
    }

    emit(state.copyWith(status: ArticlesStatus.loading));

    try {
      switch (state.from) {
        case ArticleFromEnum.flow:
          await _fetchByFlow();
          break;
        case ArticleFromEnum.hub:
          await _fetchByHub();
          break;
        case ArticleFromEnum.user:
          await _fetchByUser();
          break;
      }
    } on DisplayableException catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        status: ArticlesStatus.failure,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Не удалось получить статьи',
        status: ArticlesStatus.failure,
      ));
    }
  }

  Future<void> _fetchByFlow() async {
    var response = await _service.fetchByFlow(
      langUI: state.langUI,
      langArticles: state.langArticles,
      type: state.type,
      flow: state.flow,
      connectSid: state.connectSid,
      sort: state.sort,
      period: state.period,
      score: state.score,
      page: state.page.toString(),
    );

    emit(state.copyWith(
      status: ArticlesStatus.success,
      articles: [...state.articles, ...response.refs],
      page: state.page + 1,
      pagesCount: response.pagesCount,
    ));
  }

  Future<void> _fetchByHub() async {
    var response = await _service.fetchByHub(
      langUI: state.langUI,
      langArticles: state.langArticles,
      hub: state.hub,
      sort: state.sort,
      period: state.period,
      score: state.score,
      page: state.page.toString(),
    );

    emit(state.copyWith(
      status: ArticlesStatus.success,
      articles: [...state.articles, ...response.refs],
      page: state.page + 1,
      pagesCount: response.pagesCount,
    ));
  }

  Future<void> _fetchByUser() async {
    var response = await _service.fetchByUser(
      langUI: state.langUI,
      langArticles: state.langArticles,
      user: state.user,
      sort: state.sort,
      period: state.period,
      score: state.score,
      page: state.page.toString(),
    );

    emit(state.copyWith(
      status: ArticlesStatus.success,
      articles: [...state.articles, ...response.refs],
      page: state.page + 1,
      pagesCount: response.pagesCount,
    ));
  }
}
