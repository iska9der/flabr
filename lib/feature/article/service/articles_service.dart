import '../model/flow_enum.dart';
import '../model/network/articles_response.dart';
import '../model/sort/sort_enum.dart';
import '../model/article_model.dart';
import '../model/sort/date_period_enum.dart';
import '../repository/articles_repository.dart';

class ArticlesService {
  ArticlesService(this.repository);

  final ArticlesRepository repository;

  ArticlesResponse cached = ArticlesResponse.empty;

  /// Получение статей
  ///
  /// Сортировка полученных статей происходит как на сайте:
  /// если сортировка по лучшим [SortEnum.byBest], то надо сортировать по рейтингу;
  /// если по новым [SortEnum.byNew], сортируем по дате публикации
  ///
  Future<ArticlesResponse> fetchAll({
    required FlowEnum flow,
    required SortEnum sort,
    required DatePeriodEnum period,
    required String score,
    required String page,
  }) async {
    final response = await repository.fetchAll(
      flow: flow,
      sort: sort,
      period: period,
      score: score,
      page: page,
    );

    if (sort == SortEnum.byBest) {
      response.models.sort((a, b) => b.statistics.score.compareTo(
            a.statistics.score,
          ));
    } else {
      response.models.sort((a, b) => b.timePublished.compareTo(
            a.timePublished,
          ));
    }

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
