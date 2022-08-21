import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../common/exception/displayable_exception.dart';
import '../model/article_model.dart';
import '../service/article_service.dart';

part 'article_state.dart';

class ArticleCubit extends Cubit<ArticleState> {
  ArticleCubit(String id, {required ArticleService service})
      : _service = service,
        super(ArticleState(id: id, article: ArticleModel.empty));

  final ArticleService _service;

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
