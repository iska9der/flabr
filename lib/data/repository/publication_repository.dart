part of 'part.dart';

@LazySingleton()
class PublicationRepository {
  PublicationRepository(this.service);

  final PublicationService service;

  Future<Publication> fetchPublicationById(
    String id, {
    required PublicationSource source,
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
  }) async {
    return switch (source) {
      PublicationSource.post => await _fetchPostById(
          id,
          langUI: langUI,
          langArticles: langArticles,
        ),
      _ => await _fetchCommonById(
          id,
          langUI: langUI,
          langArticles: langArticles,
        ),
    };
  }

  Future<PublicationCommon> _fetchCommonById(
    String id, {
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
  }) async {
    final rawData = await service.fetchArticleById(
      id,
      langUI: langUI.name,
      langArticles: LanguageEncoder.encodeLangs(langArticles),
    );

    final article = PublicationCommon.fromMap(rawData);

    return article;
  }

  Future<PublicationPost> _fetchPostById(
    String id, {
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
  }) async {
    final rawData = await service.fetchPostById(
      id,
      langUI: langUI.name,
      langArticles: LanguageEncoder.encodeLangs(langArticles),
    );

    final post = PublicationPost.fromMap(rawData);

    return post;
  }

  /// Сортируем статьи в полученном списке
  void _sortListResponse(Sort sort, ListResponse response) {
    if (sort == Sort.byBest) {
      response.refs.sort(
        (a, b) => b.statistics.score.compareTo(a.statistics.score),
      );
    } else {
      response.refs.sort(
        (a, b) => b.timePublished.compareTo(a.timePublished),
      );
    }
  }

  Future<ListResponse> fetchFeed({
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
    required String page,
    required FeedFilter filter,
  }) async {
    final response = await service.fetchFeed(
      langUI: langUI.name,
      langArticles: LanguageEncoder.encodeLangs(langArticles),
      page: page,
      score: filter.score.value.isEmpty ? 'all' : filter.score.value,
      types: filter.types.map((t) => t.name).toList(),
    );

    _sortListResponse(Sort.byNew, response);

    return response;
  }

  /// Получение статей/новостей
  ///
  /// Сортировка полученных статей происходит как на сайте:
  /// если сортировка по лучшим [Sort.byBest], то надо сортировать по рейтингу;
  /// если по новым [Sort.byNew], сортируем по дате публикации
  ///
  Future<ListResponse> fetchFlowArticles({
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
    required Section section,
    required PublicationFlow flow,
    required FlowFilter filter,
    required String page,
  }) async {
    final response = await service.fetchFlowArticles(
      langUI: langUI.name,
      langArticles: LanguageEncoder.encodeLangs(langArticles),
      section: section,
      flow: flow,
      sort: filter.sort,
      period: filter.period,
      score: filter.score,
      page: page,
    );

    _sortListResponse(filter.sort, response);

    return response;
  }

  Future<PublicationListResponse> fetchHubArticles({
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
    required String hub,
    required Sort sort,
    required FilterOption period,
    required FilterOption score,
    required String page,
  }) async {
    final response = await service.fetchHubArticles(
      langUI: langUI.name,
      langArticles: LanguageEncoder.encodeLangs(langArticles),
      hub: hub,
      sort: sort,
      period: period,
      score: score,
      page: page,
    );

    _sortListResponse(sort, response);

    return response;
  }

  Future<ListResponse> fetchUserPublications({
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
    required String user,
    required String page,
    required UserPublicationType type,
  }) async {
    final response = await service.fetchUserPublications(
      langUI: langUI.name,
      langArticles: LanguageEncoder.encodeLangs(langArticles),
      user: user,
      page: page,
      type: type,
    );

    _sortListResponse(Sort.byNew, response);

    return response;
  }

  Future<ListResponse> fetchUserBookmarks({
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
    required String user,
    required String page,
    required UserBookmarksType type,
  }) async {
    final response = await service.fetchUserBookmarks(
      langUI: langUI.name,
      langArticles: LanguageEncoder.encodeLangs(langArticles),
      user: user,
      page: page,
      type: type,
    );

    var newResponse = response.copyWith(
      refs: response.ids
          .map((id) => response.refs.firstWhere((ref) => id == ref.id))
          .toList(),
    );

    return newResponse;
  }

  Future<CommentListResponse> fetchComments({
    required String articleId,
    required PublicationSource source,
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
  }) async {
    final listResponse = await service.fetchComments(
      articleId: articleId,
      source: source,
      langUI: langUI.name,
      langArticles: LanguageEncoder.encodeLangs(langArticles),
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

  Future<List<PublicationCommon>> fetchMostReading({
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
  }) async {
    final MostReadingResponse raw = await service.fetchMostReading(
      langUI: langUI.name,
      langArticles: LanguageEncoder.encodeLangs(langArticles),
    );

    List<PublicationCommon> articles = [...raw.refs];

    articles.sort((a, b) =>
        a.statistics.readingCount > b.statistics.readingCount ? 0 : 1);

    articles = articles.take(8).toList();

    return articles;
  }
}
