import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/exception/exception_helper.dart';
import '../../../component/language.dart';
import '../model/article_model.dart';
import '../repository/article_repository.dart';

part 'article_state.dart';

class ArticleCubit extends Cubit<ArticleState> {
  ArticleCubit(
    String id, {
    required ArticleRepository repository,
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
  })  : _repository = repository,
        super(ArticleState(id: id, article: ArticleModel.empty));

  final ArticleRepository _repository;

  void fetch() async {
    emit(state.copyWith(status: ArticleStatus.loading));

    try {
      final article = await _repository.fetchById(
        state.id,
        langUI: state.langUI,
        langArticles: state.langArticles,
      );

      emit(state.copyWith(status: ArticleStatus.success, article: article));
    } catch (e) {
      emit(state.copyWith(
        status: ArticleStatus.failure,
        error: ExceptionHelper.parseMessage(e),
      ));
    }
  }

  void changeLanguage({
    LanguageEnum? langUI,
    List<LanguageEnum>? langArticles,
  }) {
    emit(state.copyWith(
      status: ArticleStatus.initial,
      langUI: langUI ?? state.langUI,
      langArticles: langArticles ?? state.langArticles,
    ));
  }
}
