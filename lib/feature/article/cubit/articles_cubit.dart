import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/exception/displayable_exception.dart';
import '../../../common/exception/value_exception.dart';
import '../../../component/localization/language_enum.dart';
import '../model/article_type.dart';
import '../model/flow_enum.dart';
import '../model/sort/sort_enum.dart';
import '../model/sort/sort_option_model.dart';

import '../model/article_model.dart';
import '../model/sort/date_period_enum.dart';
import '../service/articles_service.dart';

part 'articles_state.dart';

class ArticlesCubit extends Cubit<ArticlesState> {
  ArticlesCubit(
    ArticlesService service, {
    flow = FlowEnum.all,
    type = ArticleType.article,
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
  })  : _service = service,
        super(ArticlesState(
          type: type,
          flow: flow,
          langUI: langUI,
          langArticles: langArticles,
        ));

  final ArticlesService _service;

  bool get isFirstFetch => state.page == 1;
  bool get isLastPage => state.page >= state.pagesCount;

  void fetchArticles() async {
    if (state.status == ArticlesStatus.loading || !isFirstFetch && isLastPage) {
      return;
    }

    emit(state.copyWith(status: ArticlesStatus.loading));

    try {
      var response = await _service.fetchAll(
        langUI: state.langUI,
        langArticles: state.langArticles,
        type: state.type,
        flow: state.flow,
        sort: state.sort,
        period: state.period,
        score: state.score,
        page: state.page.toString(),
      );

      emit(state.copyWith(
        status: ArticlesStatus.success,
        articles: [...state.articles, ...response.models],
        page: state.page + 1,
        pagesCount: response.pagesCount,
      ));
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

  void changeFlow(FlowEnum value) {
    if (state.flow == value) return;

    emit(ArticlesState(
      type: state.type,
      langUI: state.langUI,
      langArticles: state.langArticles,
      flow: value,
    ));
  }

  void changeSort(SortEnum value) {
    emit(ArticlesState(
      type: state.type,
      langUI: state.langUI,
      langArticles: state.langArticles,
      flow: state.flow,
      sort: value,
    ));
  }

  void changeSortOption(SortEnum sort, SortOptionModel option) {
    ArticlesState newState;
    switch (sort) {
      case SortEnum.byBest:
        if (state.period == option.value) return;

        newState = ArticlesState(period: option.value);
        break;
      case SortEnum.byNew:
        if (state.score == option.value) return;

        newState = ArticlesState(score: option.value);
        break;
      default:
        throw ValueException('Неизвестный вариант сортировки статей');
    }

    emit(newState.copyWith(
      type: state.type,
      langUI: state.langUI,
      langArticles: state.langArticles,
      sort: sort,
      flow: state.flow,
    ));
  }

  void changeLanguage({
    LanguageEnum? langUI,
    List<LanguageEnum>? langArticles,
  }) {
    emit(ArticlesState(
      type: state.type,
      flow: state.flow,
      langUI: langUI ?? state.langUI,
      langArticles: langArticles ?? state.langArticles,
    ));
  }
}
