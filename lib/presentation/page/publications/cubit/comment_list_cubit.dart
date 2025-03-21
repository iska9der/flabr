import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/exception/exception.dart';
import '../../../../data/model/language/language.dart';
import '../../../../data/model/list_response/comment_list_response.dart';
import '../../../../data/model/publication/publication_source_enum.dart';
import '../../../../data/repository/repository.dart';
import '../../../extension/extension.dart';

part 'comment_list_state.dart';

class CommentListCubit extends Cubit<CommentListState> {
  CommentListCubit(
    String publicationId, {
    required PublicationSource source,
    required PublicationRepository repository,
    required LanguageRepository languageRepository,
  }) : _repository = repository,
       _langRepository = languageRepository,
       super(CommentListState(publicationId: publicationId, source: source));

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
      emit(
        state.copyWith(
          status: CommentListStatus.failure,
          error: e.parseException('Не удалось получить данные'),
        ),
      );
    }
  }
}
