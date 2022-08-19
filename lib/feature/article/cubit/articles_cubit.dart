import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flabr/common/exception/displayable_exception.dart';
import 'package:flabr/common/exception/value_exception.dart';
import 'package:flabr/feature/article/model/article_type.dart';
import 'package:flabr/feature/article/model/sort/sort_enum.dart';
import 'package:flabr/feature/article/model/sort/sort_option_model.dart';

import '../model/article_model.dart';
import '../model/sort/period_enum.dart';
import '../service/article_service.dart';

part 'articles_state.dart';

class ArticlesCubit extends Cubit<ArticlesState> {
  ArticlesCubit(ArticleService service)
      : _service = service,
        super(const ArticlesState());

  final ArticleService _service;

  /// todo: реализовать получение по выбранному типу [ArticleType]
  void fetchArticles() async {
    emit(state.copyWith(status: ArticlesStatus.loading));

    try {
      var articles = await _service.fetchAll(
        sort: state.sort,
        period: state.period,
        score: state.score,
        page: state.page,
      );

      emit(state.copyWith(
        status: ArticlesStatus.success,
        articles: [...state.articles, ...articles],
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

  void changeType(ArticleType type) {
    if (state.type == type) return;

    emit(ArticlesState(type: type));

    fetchArticles();
  }

  void changeSort(SortEnum value) {
    emit(state.copyWith(
      sort: value,
      articles: [],
    ));

    fetchArticles();
  }

  void changeVariant(SortEnum sort, SortOptionModel option) {
    switch (sort) {
      case SortEnum.date:
        if (state.period == option.value) return;

        emit(state.copyWith(articles: [], period: option.value));
        break;
      case SortEnum.rating:
        if (state.score == option.value) {
          emit(state.copyWith(articles: [], score: ""));
        } else {
          emit(state.copyWith(articles: [], score: option.value));
        }

        break;
      default:
        throw ValueException('Неизвестный вариант сортировки статей');
    }

    fetchArticles();
  }
}
