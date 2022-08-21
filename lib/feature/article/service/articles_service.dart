import '../model/network/articles_response.dart';
import '../model/sort/sort_enum.dart';
import '../model/article_model.dart';
import '../model/sort/date_period_enum.dart';
import '../repository/articles_repository.dart';

class ArticlesService {
  ArticlesService(this.repository);

  final ArticlesRepository repository;

  ArticlesResponse cached = ArticlesResponse.empty;

  Future<ArticlesResponse> fetchAll({
    required SortEnum sort,
    required DatePeriodEnum period,
    required String score,
    required String page,
  }) async {
    final response = await repository.fetchAll(
      sort: sort,
      period: period,
      score: score,
      page: page,
    );

    cached = response;

    return cached;
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

    return result;
  }

  Future<ArticleModel> fetchById(String id) async {
    final rawData = await repository.fetchById(id);

    final article = ArticleModel.fromMap(rawData);

    return article;
  }
}
