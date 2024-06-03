import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/exception/part.dart';
import '../../../../data/model/language/part.dart';
import '../../../../data/repository/part.dart';
import '../../../../presentation/extension/part.dart';
import '../../model/comment/network/comment_list_response.dart';
import '../../model/source/publication_source.dart';

part 'comment_list_state.dart';

class CommentListCubit extends Cubit<CommentListState> {
  CommentListCubit(
    String publicationId, {
    required PublicationSource source,
    required PublicationRepository repository,
    required LanguageRepository languageRepository,
  })  : _repository = repository,
        _langRepository = languageRepository,
        super(CommentListState(
          publicationId: publicationId,
          source: source,
        ));

  final PublicationRepository _repository;
  final LanguageRepository _langRepository;

  Future<void> fetch() async {
    if (state.status.isLoading) return;

    emit(state.copyWith(status: CommentListStatus.loading));

    try {
      final newList = await _repository.fetchComments(
        articleId: state.publicationId,
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
