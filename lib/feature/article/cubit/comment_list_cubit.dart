import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/exception/displayable_exception.dart';
import '../../../../common/model/extension/state_status_x.dart';
import '../../../../component/language.dart';
import '../model/network/comment_list_response.dart';
import '../repository/article_repository.dart';

part 'comment_list_state.dart';

class CommentListCubit extends Cubit<CommentListState> {
  CommentListCubit(
    String articleId, {
    required ArticleRepository repository,
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
  })  : _repository = repository,
        super(CommentListState(
          articleId: articleId,
          langUI: langUI,
          langArticles: langArticles,
        ));

  final ArticleRepository _repository;

  Future<void> fetch() async {
    if (state.status.isLoading) return;

    emit(state.copyWith(status: CommentListStatus.loading));

    try {
      final newList = await _repository.fetchComments(
        articleId: state.articleId,
        langUI: state.langUI,
        langArticles: state.langArticles,
      );

      emit(state.copyWith(list: newList, status: CommentListStatus.success));
    } on DisplayableException catch (e) {
      emit(state.copyWith(
        status: CommentListStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
