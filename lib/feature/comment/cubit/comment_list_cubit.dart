import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/exception/displayable_exception.dart';
import '../../../common/model/extension/state_status_x.dart';
import '../../../component/language.dart';
import '../../article/service/article_service.dart';
import '../model/network/comment_list_response.dart';

part 'comment_list_state.dart';

class CommentListCubit extends Cubit<CommentListState> {
  CommentListCubit(
    String articleId, {
    required ArticleService service,
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
  })  : _service = service,
        super(CommentListState(
          articleId: articleId,
          langUI: langUI,
          langArticles: langArticles,
        ));

  final ArticleService _service;

  Future<void> fetch() async {
    if (state.status.isLoading) return;

    emit(state.copyWith(status: CommentListStatus.loading));

    try {
      final newList = await _service.fetchComments(
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
