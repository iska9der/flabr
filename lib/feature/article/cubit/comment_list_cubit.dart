import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../component/language.dart';
import '../../../common/exception/exception_helper.dart';
import '../../../common/model/extension/enum_status.dart';
import '../../publication/repository/publication_repository.dart';
import '../../settings/repository/language_repository.dart';
import '../model/helper/article_source.dart';
import '../model/network/comment_list_response.dart';

part 'comment_list_state.dart';

class CommentListCubit extends Cubit<CommentListState> {
  CommentListCubit(
    String articleId, {
    required ArticleSource source,
    required PublicationRepository repository,
    required LanguageRepository languageRepository,
  })  : _repository = repository,
        _langRepository = languageRepository,
        super(CommentListState(
          articleId: articleId,
          source: source,
        ));

  final PublicationRepository _repository;
  final LanguageRepository _langRepository;

  Future<void> fetch() async {
    if (state.status.isLoading) return;

    emit(state.copyWith(status: CommentListStatus.loading));

    try {
      final newList = await _repository.fetchComments(
        articleId: state.articleId,
        source: state.source,
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
