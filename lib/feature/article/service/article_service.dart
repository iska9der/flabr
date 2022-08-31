import '../../../component/language.dart';
import '../model/article_type.dart';
import '../model/flow_enum.dart';
import '../model/network/article_list_response.dart';
import '../model/sort/sort_enum.dart';
import '../model/article_model.dart';
import '../model/sort/date_period_enum.dart';
import '../repository/article_repository.dart';

class ArticleService {
  ArticleService(this.repository);

  final ArticleRepository repository;

  ArticleListResponse cached = ArticleListResponse.empty;

  /// Получение статей/новостей
  ///
  /// Сортировка полученных статей происходит как на сайте:
  /// если сортировка по лучшим [SortEnum.byBest], то надо сортировать по рейтингу;
  /// если по новым [SortEnum.byNew], сортируем по дате публикации
  ///
  Future<ArticleListResponse> fetchByFlow({
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
    required ArticleType type,
    required FlowEnum flow,
    required SortEnum sort,
    required DatePeriodEnum period,
    required String score,
    required String page,
  }) async {
    final response = await repository.fetchAll(
      langUI: langUI.name,
      langArticles: encodeLangs(langArticles),
      type: type,
      flow: flow,
      sort: sort,
      period: period,
      score: score,
      page: page,
    );

    if (sort == SortEnum.byBest) {
      response.refs.sort((a, b) => b.statistics.score.compareTo(
            a.statistics.score,
          ));
    } else {
      response.refs.sort((a, b) => b.timePublished.compareTo(
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

  Future<ArticleModel> fetchById(String id) async {
    final rawData = await repository.fetchById(id);

    final article = ArticleModel.fromMap(rawData);

    return article;
  }

  Future<ArticleListResponse> fetchByHub({
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
    required String hub,
    required SortEnum sort,
    required DatePeriodEnum period,
    required String score,
    required String page,
  }) async {
    final response = await repository.fetchByHub(
      langUI: langUI.name,
      langArticles: encodeLangs(langArticles),
      hub: hub,
      sort: sort,
      period: period,
      score: score,
      page: page,
    );

    if (sort == SortEnum.byBest) {
      response.refs.sort((a, b) => b.statistics.score.compareTo(
            a.statistics.score,
          ));
    } else {
      response.refs.sort((a, b) => b.timePublished.compareTo(
            a.timePublished,
          ));
    }

    cached = response;

    return cached;
  }
}
