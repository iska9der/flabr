import '../../../component/localization/language_enum.dart';
import '../../../component/localization/language_helper.dart';
import '../model/article_model.dart';
import '../model/article_type.dart';
import '../model/flow_enum.dart';
import '../model/network/article_list_response.dart';
import '../model/network/comment_list_response.dart';
import '../model/sort/date_period_enum.dart';
import '../model/sort/sort_enum.dart';
import '../service/article_service.dart';

class ArticleRepository {
  ArticleRepository(this.service);

  final ArticleService service;

  ArticleListResponse cached = ArticleListResponse.empty;

  Future<ArticleModel> fetchById(
    String id, {
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
  }) async {
    final rawData = await service.fetchById(
      id,
      langUI: langUI.name,
      langArticles: encodeLangs(langArticles),
    );

    final article = ArticleModel.fromMap(rawData);

    return article;
  }

  /// Сортируем статьи в полученном списке
  void _sortListResponse(SortEnum sort, ArticleListResponse response) {
    if (sort == SortEnum.byBest) {
      response.refs.sort((a, b) => b.statistics.score.compareTo(
            a.statistics.score,
          ));
    } else {
      response.refs.sort((a, b) => b.timePublished.compareTo(
            a.timePublished,
          ));
    }
  }

  /// Получение статей/новостей
  ///
  /// Сортировка полученных статей происходит как на сайте:
  /// если сортировка по лучшим [SortEnum.byBest], то надо сортировать по рейтингу;
  /// если по новым [SortEnum.byNew], сортируем по дате публикации
  ///
  Future<ArticleListResponse> fetchFlowArticles({
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
    required ArticleType type,
    required FlowEnum flow,
    required SortEnum sort,
    required DatePeriodEnum period,
    required String score,
    required String page,
  }) async {
    final response = await service.fetchFlowArticles(
      langUI: langUI.name,
      langArticles: encodeLangs(langArticles),
      type: type,
      flow: flow,
      sort: sort,
      period: period,
      score: score,
      page: page,
    );

    _sortListResponse(sort, response);

    cached = response;

    return cached;
  }

  Future<ArticleListResponse> fetchHubArticles({
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
    required String hub,
    required SortEnum sort,
    required DatePeriodEnum period,
    required String score,
    required String page,
  }) async {
    final response = await service.fetchHubArticles(
      langUI: langUI.name,
      langArticles: encodeLangs(langArticles),
      hub: hub,
      sort: sort,
      period: period,
      score: score,
      page: page,
    );

    _sortListResponse(sort, response);

    cached = response;

    return cached;
  }

  fetchUserArticles({
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
    required String user,
    required SortEnum sort,
    required DatePeriodEnum period,
    required String score,
    required String page,
  }) async {
    final response = await service.fetchUserArticles(
      langUI: langUI.name,
      langArticles: encodeLangs(langArticles),
      user: user,
      sort: sort,
      period: period,
      score: score,
      page: page,
    );

    _sortListResponse(sort, response);

    cached = response;

    return cached;
  }

  fetchUserBookmarks({
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
    required String user,
    required String page,
  }) async {
    final response = await service.fetchUserBookmarks(
      langUI: langUI.name,
      langArticles: encodeLangs(langArticles),
      user: user,
      page: page,
    );

    var newResponse = response.copyWith(
      refs: response.ids.map(
        (id) {
          return response.refs.firstWhere((ref) => id == ref.id);
        },
      ).toList(),
    );
    cached = newResponse;

    return cached;
  }

  Future<CommentListResponse> fetchComments({
    required String articleId,
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
  }) async {
    final listResponse = await service.fetchComments(
      articleId: articleId,
      langUI: langUI.name,
      langArticles: encodeLangs(langArticles),
    );

    final structurizedComments = listResponse.structurize();

    return listResponse.copyWith(comments: structurizedComments);
  }

  Future<bool> addToBookmark(String articleId) async {
    return await service.addToBookmark(articleId);
  }

  Future<bool> removeFromBookmark(String articleId) async {
    return await service.removeFromBookmark(articleId);
  }
}
