part of 'part.dart';

abstract interface class PublicationService {
  Future<Map<String, dynamic>> fetchCounters();

  Future<Map<String, dynamic>> fetchArticleById(
    String id, {
    required String langUI,
    required String langArticles,
  });

  Future<Map<String, dynamic>> fetchPostById(
    String id, {
    required String langUI,
    required String langArticles,
  });

  Future<ListResponse> fetchFeed({
    required String langUI,
    required String langArticles,
    required String page,
    required String score,
    required List<String> types,
  });

  Future<ListResponse> fetchFlowArticles({
    required String langUI,
    required String langArticles,
    required Section section,
    required PublicationFlow flow,
    required Sort sort,
    required String page,
    required FilterOption period,
    required FilterOption score,
  });

  Future<PublicationListResponse> fetchHubArticles({
    required String langUI,
    required String langArticles,
    required String hub,
    required Sort sort,
    required FilterOption period,
    required FilterOption score,
    required String page,
  });

  Future<ListResponse> fetchUserPublications({
    required String langUI,
    required String langArticles,
    required String user,
    required String page,
    required UserPublicationType type,
  });

  Future<ListResponse> fetchUserBookmarks({
    required String langUI,
    required String langArticles,
    required String user,
    required String page,
    required UserBookmarksType type,
  });

  Future<CommentListResponse> fetchComments({
    required String articleId,
    required PublicationSource source,
    required String langUI,
    required String langArticles,
  });

  Future<bool> addToBookmark(String articleId);

  Future<bool> removeFromBookmark(String articleId);

  fetchMostReading({
    required String langUI,
    required String langArticles,
  });

  Future<PublicationVoteResponse> voteUp(String articleId);

  Future<PublicationVoteResponse> voteDown(String articleId);
}

@LazySingleton(as: PublicationService)
class PublicationServiceImpl implements PublicationService {
  const PublicationServiceImpl({
    @Named('mobileClient') required HttpClient mobileClient,
    @Named('siteClient') required HttpClient siteClient,
  })  : _mobileClient = mobileClient,
        _siteClient = siteClient;

  final HttpClient _mobileClient;
  final HttpClient _siteClient;

  @override
  Future<Map<String, dynamic>> fetchCounters() async {
    try {
      final response = await _mobileClient.get('/feed/counters');

      return response.data;
    } catch (e, trace) {
      Error.throwWithStackTrace(FetchException(), trace);
    }
  }

  @override
  Future<Map<String, dynamic>> fetchArticleById(
    String id, {
    required String langUI,
    required String langArticles,
  }) async {
    try {
      final params = Params(langArticles: langArticles, langUI: langUI);

      final response = await _mobileClient.get(
        '/articles/$id/?${params.toQueryString()}',
      );

      return response.data;
    } catch (e, trace) {
      Error.throwWithStackTrace(FetchException(), trace);
    }
  }

  @override
  Future<Map<String, dynamic>> fetchPostById(
    String id, {
    required String langUI,
    required String langArticles,
  }) async {
    try {
      final params = Params(langArticles: langArticles, langUI: langUI);

      final response = await _mobileClient.get(
        '/threads/$id/?${params.toQueryString()}',
      );

      return response.data;
    } catch (e, trace) {
      Error.throwWithStackTrace(FetchException(), trace);
    }
  }

  @override
  Future<ListResponse> fetchFeed({
    required String langUI,
    required String langArticles,
    required String page,
    required String score,
    required List<String> types,
  }) async {
    try {
      final params = FeedListParams(
        langArticles: langArticles,
        langUI: langUI,
        page: page,
        score: score,
        types: types,
      );

      final response = await _mobileClient.get(
        '/articles',
        queryParams: params.toMap(),
      );

      return FeedListResponse.fromMap(response.data);
    } on DisplayableException {
      rethrow;
    } catch (e, trace) {
      Error.throwWithStackTrace(FetchException(), trace);
    }
  }

  @override
  Future<ListResponse> fetchFlowArticles({
    required String langUI,
    required String langArticles,
    required Section section,
    required PublicationFlow flow,
    required Sort sort,
    required FilterOption period,
    required FilterOption score,
    required String page,
  }) async {
    try {
      final flowStr = (flow == PublicationFlow.all) ? null : flow.name;

      final params = switch (section) {
        Section.post => PostListParams(
            langArticles: langArticles,
            langUI: langUI,
            page: page,
            flow: flowStr,
            sort: sort.postValue,
            period: sort == Sort.byBest ? period.value : null,
            score: score.value,
          ),
        _ => PublicationListParams(
            langArticles: langArticles,
            langUI: langUI,
            page: page,
            flow: flowStr,
            news: section == Section.news,

            /// если мы находимся не во "Все потоки", в значение sort, по завету
            /// костыльного api хабра, нужно передавать значение 'all'
            sort: flow == PublicationFlow.all ? sort.value : 'all',
            period: sort == Sort.byBest ? period.value : null,
            score: score.value,
          ),
      };

      final response = await _mobileClient.get(
        '/articles',
        queryParams: params.toMap(),
      );

      return switch (section) {
        Section.post => PostListResponse.fromMap(response.data),
        _ => PublicationListResponse.fromMap(response.data),
      } as ListResponse;
    } on DisplayableException {
      rethrow;
    } catch (e, trace) {
      Error.throwWithStackTrace(FetchException(), trace);
    }
  }

  @override
  Future<PublicationListResponse> fetchHubArticles({
    required String langUI,
    required String langArticles,
    required String hub,
    required Sort sort,
    required FilterOption period,
    required FilterOption score,
    required String page,
  }) async {
    try {
      final params = PublicationListParams(
        langArticles: langArticles,
        langUI: langUI,
        page: page,
        sort: 'all',
        period: sort == Sort.byBest ? period.value : null,
        score: score.value,
      );

      final response = await _mobileClient.get(
        '/articles/?hub=$hub',
        queryParams: params.toMap(),
      );

      return PublicationListResponse.fromMap(response.data);
    } on DisplayableException {
      rethrow;
    } catch (e, trace) {
      Error.throwWithStackTrace(FetchException(), trace);
    }
  }

  @override
  Future<ListResponse> fetchUserPublications({
    required String langUI,
    required String langArticles,
    required String user,
    required String page,
    required UserPublicationType type,
  }) async {
    try {
      final params = PublicationListParams(
        langArticles: langArticles,
        langUI: langUI,
        page: page,
      );

      final String typeQuery = switch (type) {
        UserPublicationType.articles => '',
        UserPublicationType.posts => '&posts=true',
        UserPublicationType.news => '&news=true',
      };

      final response = await _mobileClient.get(
        '/articles/?user=$user$typeQuery',
        queryParams: params.toMap(),
      );

      return switch (type) {
        UserPublicationType.posts => PostListResponse.fromMap(response.data),
        _ => PublicationListResponse.fromMap(response.data),
      } as ListResponse;
    } on DisplayableException {
      rethrow;
    } catch (e, trace) {
      Error.throwWithStackTrace(FetchException(), trace);
    }
  }

  @override
  Future<ListResponse> fetchUserBookmarks({
    required String langUI,
    required String langArticles,
    required String user,
    required String page,
    required UserBookmarksType type,
  }) async {
    try {
      final params = PublicationListParams(
        langArticles: langArticles,
        langUI: langUI,
        page: page,
      );

      final String typeQuery = switch (type) {
        UserBookmarksType.articles => 'user_bookmarks=true',
        UserBookmarksType.posts => 'user_bookmarks_posts=true',
        UserBookmarksType.news => 'user_bookmarks_news=true',
        UserBookmarksType.comments =>
          throw ValueException('Вы не туда попали...'),
      };

      final queryString = params.toQueryString();
      final response = await _mobileClient.get(
        '/articles/?user=$user&$typeQuery&$queryString',
      );

      return switch (type) {
        UserBookmarksType.posts => PostListResponse.fromMap(response.data),
        _ => PublicationListResponse.fromMap(response.data),
      } as ListResponse;
    } on DisplayableException {
      rethrow;
    } catch (e, trace) {
      Error.throwWithStackTrace(FetchException(), trace);
    }
  }

  @override
  Future<CommentListResponse> fetchComments({
    required String articleId,
    required PublicationSource source,
    required String langUI,
    required String langArticles,
  }) async {
    try {
      final params = CommentListParams(
        langArticles: langArticles,
        langUI: langUI,
      );

      final firstPathPart = switch (source) {
        PublicationSource.post => 'threads',
        _ => 'articles',
      };

      final queryString = params.toQueryString();
      final response = await _mobileClient.get(
        '/$firstPathPart/$articleId/comments/$queryString',
      );

      return CommentListResponse.fromMap(response.data);
    } on DisplayableException {
      rethrow;
    } on DioException catch (e, trace) {
      Error.throwWithStackTrace(
        CommentsListException.fromDioException(e),
        trace,
      );
    } catch (e, trace) {
      Error.throwWithStackTrace(FetchException(), trace);
    }
  }

  @override
  Future<bool> addToBookmark(String articleId) async {
    try {
      final response = await _siteClient.post(
        '/v2/articles/$articleId/bookmarks/',
        body: {},
      );

      if (response.data['ok'] != true) {
        throw ValueException('Не удалось!');
      }

      return true;
    } on DisplayableException {
      rethrow;
    } catch (e, trace) {
      Error.throwWithStackTrace(FetchException(), trace);
    }
  }

  @override
  Future<bool> removeFromBookmark(String articleId) async {
    try {
      final response = await _siteClient.delete(
        '/v2/articles/$articleId/bookmarks/',
      );

      if (response.data['ok'] != true) {
        throw ValueException('Не удалось!');
      }

      return true;
    } on DisplayableException {
      rethrow;
    } catch (e, trace) {
      Error.throwWithStackTrace(FetchException(), trace);
    }
  }

  @override
  fetchMostReading({
    required String langUI,
    required String langArticles,
  }) async {
    try {
      final params = PublicationListParams(
        langArticles: langArticles,
        langUI: langUI,
      );

      final queryString = params.toQueryString();
      final response = await _mobileClient.get(
        '/articles/most-reading?$queryString',
      );

      return MostReadingResponse.fromMap(response.data);
    } on DisplayableException {
      rethrow;
    } catch (e, trace) {
      Error.throwWithStackTrace(FetchException(), trace);
    }
  }

  @override
  Future<PublicationVoteResponse> voteUp(String publicationId) async {
    try {
      final response = await _siteClient.post(
        '/v2/articles/$publicationId/votes/up',
        body: {},
      );

      return PublicationVoteResponse.fromJson(response.data);
    } catch (e, trace) {
      Error.throwWithStackTrace(FetchException(), trace);
    }
  }

  @override
  Future<PublicationVoteResponse> voteDown(String publicationId) async {
    try {
      final response = await _siteClient.post(
        '/v2/articles/$publicationId/votes/down',
        body: {},
      );

      return PublicationVoteResponse.fromJson(response.data);
    } catch (e, trace) {
      Error.throwWithStackTrace(FetchException(), trace);
    }
  }
}
