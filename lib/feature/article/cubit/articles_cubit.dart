import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../common/exception/displayable_exception.dart';
import '../../../common/exception/value_exception.dart';
import '../model/articles_enum.dart';
import '../model/sort/sort_enum.dart';
import '../model/sort/sort_option_model.dart';

import '../model/article_model.dart';
import '../model/sort/date_period_enum.dart';
import '../service/articles_service.dart';

part 'articles_state.dart';

class ArticlesCubit extends Cubit<ArticlesState> {
  ArticlesCubit(ArticlesService service)
      : _service = service,
        super(const ArticlesState());

  final ArticlesService _service;

  bool get isFirstFetch => state.page == 1;
  bool get isLastPage => state.page >= state.pagesCount;

  /// todo: реализовать получение по выбранному типу [ArticlesEnum]
  ///
  /// todo: реализовать бесконечную загрузку постов
  void fetchArticles() async {
    if (state.status == ArticlesStatus.loading || !isFirstFetch && isLastPage) {
      return;
    }

    emit(state.copyWith(status: ArticlesStatus.loading));

    try {
      var response = await _service.fetchAll(
        sort: state.sort,
        period: state.period,
        score: state.score,
        page: state.page.toString(),
      );

      emit(state.copyWith(
        status: ArticlesStatus.success,
        articles: [...state.articles, ...response.articles],
        page: state.page + 1,
        pagesCount: response.pagesCount,
      ));
    } on DisplayableException catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        status: ArticlesStatus.error,
      ));
    }
  }

  fetchNews() async {
    emit(state.copyWith(status: ArticlesStatus.loading));

    try {
      var articles = await _service.fetchNews();

      emit(state.copyWith(
        status: ArticlesStatus.success,
        articles: [...state.articles, ...articles],
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Не удалось получить новости',
        status: ArticlesStatus.error,
      ));
    }
  }

  void changeType(ArticlesEnum type) {
    if (state.type == type) return;

    emit(ArticlesState(type: type));

    fetchArticles();
  }

  void changeSort(SortEnum value) {
    emit(ArticlesState(sort: value));

    fetchArticles();
  }

  void changeSortOption(SortEnum sort, SortOptionModel option) {
    switch (sort) {
      case SortEnum.date:
        if (state.period == option.value) return;

        emit(ArticlesState(sort: sort, period: option.value));
        break;
      case SortEnum.rating:
        if (state.score == option.value) return;

        emit(ArticlesState(sort: sort, score: option.value));
        break;
      default:
        throw ValueException('Неизвестный вариант сортировки статей');
    }

    fetchArticles();
  }
}
