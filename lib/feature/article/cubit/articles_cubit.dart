import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flabr/feature/article/model/article_type.dart';

import '../model/article_model.dart';
import '../service/article_service.dart';

part 'articles_state.dart';

class ArticlesCubit extends Cubit<ArticlesState> {
  ArticlesCubit(ArticleService service)
      : _service = service,
        super(const ArticlesState());

  final ArticleService _service;

  void fetchArticles() async {
    emit(state.copyWith(status: ArticlesStatus.loading));

    try {
      var articles = await _service.fetchAll();

      emit(state.copyWith(
        status: ArticlesStatus.success,
        articles: [...state.articles, ...articles],
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Не удалось получить статьи',
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
}
