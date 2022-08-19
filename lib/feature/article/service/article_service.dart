import 'package:flabr/feature/article/model/sort/sort_enum.dart';

import '../model/article_model.dart';
import '../repository/article_repository.dart';

class ArticleService {
  ArticleService(this.repository);

  final ArticleRepository repository;

  List<ArticleModel> cached = const [];

  Future<List<ArticleModel>> fetchAll({
    required SortEnum sort,
    required String page,
  }) async {
    final raw = await repository.fetchAll(sort: sort, page: page);

    final refs =
        raw.entries.firstWhere((e) => e.key == 'articleRefs').value as Map;

    final result = refs.entries

        /// только статьи, новости откидываем
        .where((e) => e.value['postType'] == 'article')
        .map((e) => ArticleModel.fromMap(e.value))
        .toList();

    cached = result;

    return result;
  }

  /// todo: unimplemented
  Future<List<ArticleModel>> fetchFeed({
    required SortEnum sort,
    required String page,
  }) async {
    final raw = await repository.fetchFeed(sort: sort, page: page);

    final refs =
        raw.entries.firstWhere((e) => e.key == 'articleRefs').value as Map;

    final result = refs.entries

        /// только статьи, новости откидываем
        .where((e) => e.value['postType'] == 'article')
        .map((e) => ArticleModel.fromMap(e.value))
        .toList();

    cached = result;

    return result;
  }

  Future<List<ArticleModel>> fetchNews() async {
    final raw = await repository.fetchNews();

    final refs =
        raw.entries.firstWhere((e) => e.key == 'articleRefs').value as Map;

    final result = refs.entries

        /// только статьи, новости откидываем
        .where((e) => e.value['postType'] == 'news')
        .map((e) => ArticleModel.fromMap(e.value))
        .toList();

    cached = result;

    return result;
  }
}
