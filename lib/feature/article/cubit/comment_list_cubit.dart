import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../component/language.dart';
import '../../../common/exception/exception_helper.dart';
import '../../../common/model/extension/enum_status.dart';
import '../../settings/repository/language_repository.dart';
import '../model/network/comment_list_response.dart';
import '../repository/article_repository.dart';

part 'comment_list_state.dart';

class CommentListCubit extends Cubit<CommentListState> {
  CommentListCubit(
    String articleId, {
    required ArticleRepository repository,
    required LanguageRepository languageRepository,
  })  : _repository = repository,
        _langRepository = languageRepository,
        super(CommentListState(articleId: articleId));

  final ArticleRepository _repository;
  final LanguageRepository _langRepository;

  Future<void> fetch() async {
    if (state.status.isLoading) return;

    emit(state.copyWith(status: CommentListStatus.loading));

    try {
      final newList = await _repository.fetchComments(
        articleId: state.articleId,
        langUI: _langRepository.ui,
        langArticles: _langRepository.articles,
      );

      emit(state.copyWith(list: newList, status: CommentListStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: CommentListStatus.failure,
        error: ExceptionHelper.parseMessage(e, 'Не удалось получить данные'),
      ));
    }
  }
}
