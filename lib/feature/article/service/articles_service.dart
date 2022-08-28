import '../../../component/language.dart';
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
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
    required FlowEnum flow,
    required SortEnum sort,
    required DatePeriodEnum period,
    required String score,
    required String page,
  }) async {
    final response = await repository.fetchAll(
      langUI: langUI.name,
      langArticles: encodeLangs(langArticles),
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

  Future<ArticlesResponse> fetchNews({
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
    required String page,
  }) async {
    final response = await repository.fetchNews(
      langUI: langUI,
      langArticles: encodeLangs(langArticles),
      page: page,
    );

    return response;
  }

  Future<ArticleModel> fetchById(String id) async {
    final rawData = await repository.fetchById(id);

    final article = ArticleModel.fromMap(rawData);

    return article;
  }
}
