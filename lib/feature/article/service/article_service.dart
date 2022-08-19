import 'package:flabr/feature/article/model/sort/sort_enum.dart';

import '../model/article_model.dart';
import '../model/sort/date_period_enum.dart';
import '../repository/article_repository.dart';

class ArticleService {
  ArticleService(this.repository);

  final ArticleRepository repository;

  List<ArticleModel> cached = const [];

  Future<List<ArticleModel>> fetchAll({
    required SortEnum sort,
    required DatePeriodEnum period,
    required String score,
    required String page,
  }) async {
    final raw = await repository.fetchAll(
      sort: sort,
      period: period,
      score: score,
      page: page,
    );

    final refs =
        raw.entries.firstWhere((e) => e.key == 'articleRefs').value as Map;

    final result = refs.entries

        /// только статьи, новости откидываем
        .where((e) => e.value['postType'] == 'article')
        .map((e) => ArticleModel.fromMap(e.value))
        .toList()
        .reversed
        .toList();

    cached = result;

    return result;
  }

  /// todo: unimplemented
  void fetchFeed() {
    repository.fetchFeed();
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
