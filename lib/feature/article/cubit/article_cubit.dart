import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/exception/exception_helper.dart';
import '../../../common/model/extension/enum_status.dart';
import '../../publication/model/source/publication_source.dart';
import '../../publication/repository/publication_repository.dart';
import '../../settings/repository/language_repository.dart';
import '../model/article_model.dart';

part 'article_state.dart';

class ArticleCubit extends Cubit<ArticleState> {
  ArticleCubit(
    String id, {
    required PublicationSource source,
    required PublicationRepository repository,
    required LanguageRepository languageRepository,
  })  : _repository = repository,
        _languageRepository = languageRepository,
        super(ArticleState(
          id: id,
          source: source,
          article: ArticleModel.empty,
        )) {
    _uiLangSub = _languageRepository.uiStream.listen(
      (_) => _reInit(),
    );
    _articlesLangSub = _languageRepository.articlesStream.listen(
      (_) => _reInit(),
    );
  }

  final PublicationRepository _repository;
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
        source: state.source,
        langUI: _languageRepository.ui,
        langArticles: _languageRepository.articles,
      );

      emit(state.copyWith(status: ArticleStatus.success, article: article));
    } catch (e) {
      emit(state.copyWith(
        status: ArticleStatus.failure,
        error: ExceptionHelper.parseMessage(e),
      ));

      rethrow;
    }
  }

  void _reInit() {
    emit(state.copyWith(status: ArticleStatus.initial));
  }
}
