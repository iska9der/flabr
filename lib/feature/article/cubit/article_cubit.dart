import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/exception/displayable_exception.dart';
import '../model/article_model.dart';
import '../service/articles_service.dart';

part 'article_state.dart';

class ArticleCubit extends Cubit<ArticleState> {
  ArticleCubit(String id, {required ArticlesService service})
      : _service = service,
        super(ArticleState(id: id, article: ArticleModel.empty));

  final ArticlesService _service;

  void fetch() async {
    emit(state.copyWith(status: ArticleStatus.loading));

    try {
      final article = await _service.fetchById(state.id);

      emit(state.copyWith(status: ArticleStatus.success, article: article));
    } on DisplayableException catch (e) {
      emit(state.copyWith(status: ArticleStatus.failure, error: e.toString()));
    }
  }
}
