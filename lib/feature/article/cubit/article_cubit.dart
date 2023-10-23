import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/exception/exception_helper.dart';
import '../../../common/model/extension/enum_status.dart';
import '../../settings/repository/language_repository.dart';
import '../model/article_model.dart';
import '../repository/article_repository.dart';

part 'article_state.dart';

class ArticleCubit extends Cubit<ArticleState> {
  ArticleCubit(
    String id, {
    required ArticleRepository repository,
    required LanguageRepository languageRepository,
  })  : _repository = repository,
        _languageRepository = languageRepository,
        super(ArticleState(id: id, article: ArticleModel.empty)) {
    _uiLangSub = _languageRepository.uiStream.listen(
      (_) => _reInit(),
    );
    _articlesLangSub = _languageRepository.articlesStream.listen(
      (_) => _reInit(),
    );
  }

  final ArticleRepository _repository;
  final LanguageRepository _languageRepository;

  late final StreamSubscription _uiLangSub;
  late final StreamSubscription _articlesLangSub;

  @override
  Future<void> close() {
    _uiLangSub.cancel();
    _articlesLangSub.cancel();

    return super.close();
  }

  void fetch() async {
    if (state.status.isLoading) return;

    emit(state.copyWith(status: ArticleStatus.loading));

    try {
      final article = await _repository.fetchById(
        state.id,
        langUI: _languageRepository.ui,
        langArticles: _languageRepository.articles,
      );

      emit(state.copyWith(status: ArticleStatus.success, article: article));
    } catch (e) {
      emit(state.copyWith(
        status: ArticleStatus.failure,
        error: ExceptionHelper.parseMessage(e),
      ));
    }
  }

  void _reInit() {
    emit(state.copyWith(status: ArticleStatus.initial));
  }
}
