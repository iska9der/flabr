import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'articles_state.dart';

class ArticlesCubit extends Cubit<ArticlesState> {
  ArticlesCubit() : super(ArticlesInitial());
}
