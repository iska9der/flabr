import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/exception/displayable_exception.dart';
import '../model/article_model.dart';
import '../repository/article_repository.dart';

part 'article_state.dart';

class ArticleCubit extends Cubit<ArticleState> {
  ArticleCubit(String id, {required ArticleRepository repository})
      : _repository = repository,
        super(ArticleState(id: id, article: ArticleModel.empty));

  final ArticleRepository _repository;

  void fetch() async {
    emit(state.copyWith(status: ArticleStatus.loading));

    try {
      final article = await _repository.fetchById(state.id);

      emit(state.copyWith(status: ArticleStatus.success, article: article));
    } on DisplayableException catch (e) {
      emit(state.copyWith(status: ArticleStatus.failure, error: e.toString()));
    }
  }
}
