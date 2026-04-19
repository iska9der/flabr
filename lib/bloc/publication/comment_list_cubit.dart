import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/exception/exception.dart';
import '../../data/model/comment/comment.dart';
import '../../data/model/language/language.dart';
import '../../data/model/loading_status_enum.dart';
import '../../data/model/publication/publication.dart';
import '../../data/repository/repository.dart';

part 'comment_list_state.dart';

class CommentListCubit extends Cubit<CommentListState> {
  CommentListCubit(
    String publicationId, {
    required PublicationSource source,
    required PublicationRepository repository,
    required LanguageRepository languageRepository,
  }) : _repository = repository,
       super(CommentListState(publicationId: publicationId, source: source));

  final PublicationRepository _repository;

  Future<void> fetch() async {
    if (state.status == .loading) return;

    emit(state.copyWith(status: .loading));

    try {
      final newList = await _repository.fetchComments(
        articleId: state.publicationId,
        source: state.source,
      );

      emit(state.copyWith(list: newList, status: .success));
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: .failure,
          error: error.parseException('Не удалось получить комментарии'),
        ),
      );

      super.onError(error, stackTrace);
    }
  }
}
