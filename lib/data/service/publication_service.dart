import 'package:injectable/injectable.dart';

import '../../core/component/http/http.dart';
import '../exception/exception.dart';
import '../model/comment/comment.dart';
import '../model/filter/filter.dart';
import '../model/list_response_model.dart';
import '../model/publication/publication.dart';
import '../model/section_enum.dart';
import '../model/user/user.dart';

abstract interface class PublicationService {
  Future<PublicationCounters> fetchCounters();

  Future<PublicationCommon> fetchArticleById(String id);

  Future<PublicationPost> fetchPostById(String id);

  Future<ListResponse<Publication>> fetchFeed({
    required String page,
    required String score,
    required List<String> types,
  });

  Future<ListResponse<Publication>> fetchFlowArticles({
    required Section section,
    required PublicationFlow flow,
    required Sort sort,
    required String page,
    required FilterOption period,
    required FilterOption score,
  });

  Future<ListResponse<Publication>> fetchHubArticles({
    required String hub,
    required Sort sort,
    required FilterOption period,
    required FilterOption score,
    required String page,
  });

  Future<ListResponse<Publication>> fetchUserPublications({
    required String user,
    required String page,
    required UserPublicationType type,
  });

  Future<ListResponse<Publication>> fetchUserBookmarks({
    required String user,
    required String page,
    required UserBookmarksType type,
  });

  Future<CommentListResponse> fetchComments({
    required String articleId,
    required PublicationSource source,
  });

  Future<bool> addToBookmark({
    required String id,
    required PublicationSource source,
  });

  Future<bool> removeFromBookmark({
    required String id,
    required PublicationSource source,
  });

  Future<MostReadingResponse> fetchMostReading();

  Future<PublicationVoteResponse> voteUp(String articleId);

  Future<PublicationVoteResponse> voteDown(String articleId);
}

@LazySingleton(as: PublicationService)
class PublicationServiceImpl implements PublicationService {
  const PublicationServiceImpl({
    @Named('siteClient') required this._siteClient,
  });

  final HttpClient _siteClient;

  @override
  Future<PublicationCounters> fetchCounters() async {
    final response = await _siteClient.get('/v2/feed/counters');

    return PublicationCounters.fromJson(response.data);
  }

  @override
  Future<PublicationCommon> fetchArticleById(String id) async {
    final response = await _siteClient.get('/v2/articles/$id/');

    return PublicationCommon.fromJson(response.data);
  }

  @override
  Future<PublicationPost> fetchPostById(String id) async {
    final response = await _siteClient.get('/v2/threads/$id/');

    return PublicationPost.fromJson(response.data);
  }

  @override
  Future<ListResponse<Publication>> fetchFeed({
    required String page,
    required String score,
    required List<String> types,
  }) async {
    final params = FeedListParams(
      page: page,
      score: score,
      types: types,
    ).toMap();

    final response = await _siteClient.get(
      '/v2/articles/',
      queryParams: params,
    );

    return FeedListResponse.fromMap(response.data);
  }

  @override
  Future<ListResponse<Publication>> fetchFlowArticles({
    required Section section,
    required PublicationFlow flow,
    required Sort sort,
    required FilterOption period,
    required FilterOption score,
    required String page,
  }) async {
    final flowStr = (flow == PublicationFlow.all) ? null : flow.alias;

    final params = switch (section) {
      Section.post => PublicationPostListParams(
        page: page,
        flow: flowStr,
        sort: sort.postValue,
        period: sort == Sort.byBest ? period.value : null,
        score: score.value,
      ),
      _ => PublicationListParams(
        page: page,
        flow: flowStr,
        news: section == Section.news,

        /// если мы находимся не во "Все потоки", в значение sort, по завету
        /// костыльного api хабра, нужно передавать значение 'all'
        sort: flow == PublicationFlow.all ? sort.value : 'all',
        period: sort == Sort.byBest ? period.value : null,
        score: score.value,
      ),
    }.toMap();

    final response = await _siteClient.get(
      '/v2/articles/',
      queryParams: params,
    );

    return switch (section) {
      Section.post => PublicationPostListResponse.fromMap(response.data),
      _ => PublicationCommonListResponse.fromMap(response.data),
    };
  }

  @override
  Future<ListResponse<Publication>> fetchHubArticles({
    required String hub,
    required Sort sort,
    required FilterOption period,
    required FilterOption score,
    required String page,
  }) async {
    final params = PublicationListParams(
      page: page,
      sort: 'all',
      period: sort == Sort.byBest ? period.value : null,
      score: score.value,
    ).toMap();

    params.addAll({'hub': hub});

    final response = await _siteClient.get(
      '/v2/articles/',
      queryParams: params,
    );

    return PublicationCommonListResponse.fromMap(response.data);
  }

  @override
  Future<ListResponse<Publication>> fetchUserPublications({
    required String user,
    required String page,
    required UserPublicationType type,
  }) async {
    final params = PublicationListParams(page: page).toMap();

    final typeQuery = switch (type) {
      UserPublicationType.articles => null,
      UserPublicationType.posts => {'posts': 'true'},
      UserPublicationType.news => {'news': 'true'},
    };

    params.addAll({'user': user});
    if (typeQuery != null) {
      params.addAll(typeQuery);
    }

    final response = await _siteClient.get(
      '/v2/articles/',
      queryParams: params,
    );

    return switch (type) {
      UserPublicationType.posts => PublicationPostListResponse.fromMap(
        response.data,
      ),
      _ => PublicationCommonListResponse.fromMap(response.data),
    };
  }

  @override
  Future<ListResponse<Publication>> fetchUserBookmarks({
    required String user,
    required String page,
    required UserBookmarksType type,
  }) async {
    final params = PublicationListParams(page: page).toMap();

    final typeQuery = switch (type) {
      UserBookmarksType.articles => {'user_bookmarks': 'true'},
      UserBookmarksType.posts => {'user_bookmarks_posts': 'true'},
      UserBookmarksType.news => {'user_bookmarks_news': 'true'},
      UserBookmarksType.comments => throw const ValueException(
        .wrongPublicationDestination,
      ),
    };

    params.addAll({'user': user, ...typeQuery});

    final response = await _siteClient.get(
      '/v2/articles/',
      queryParams: params,
    );

    return switch (type) {
      UserBookmarksType.posts => PublicationPostListResponse.fromMap(
        response.data,
      ),
      _ => PublicationCommonListResponse.fromMap(response.data),
    };
  }

  @override
  Future<CommentListResponse> fetchComments({
    required String articleId,
    required PublicationSource source,
  }) async {
    try {
      final firstPathPart = switch (source) {
        PublicationSource.post => 'threads',
        _ => 'articles',
      };

      final response = await _siteClient.get(
        '/v2/$firstPathPart/$articleId/comments/',
      );

      return CommentListResponse.fromMap(response.data);
    } on FetchException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        CommentsListException.fromFetchException(error),
        stackTrace,
      );
    }
  }

  @override
  Future<bool> addToBookmark({
    required String id,
    required PublicationSource source,
  }) async {
    final sourcePath = switch (source) {
      PublicationSource.post => 'threads',
      PublicationSource.news => 'news',
      _ => 'articles',
    };

    /// для постов в конце пути добавляется слово "add"
    final append = switch (source) {
      PublicationSource.post => 'add/',
      _ => '',
    };

    final response = await _siteClient.post(
      '/v2/$sourcePath/$id/bookmarks/$append',
      body: {},
    );

    if (response.data['ok'] != true) {
      throw const ValueException(.publicationOperationFailed);
    }

    return true;
  }

  @override
  Future<bool> removeFromBookmark({
    required String id,
    required PublicationSource source,
  }) async {
    final sourcePath = switch (source) {
      PublicationSource.post => 'threads',
      PublicationSource.news => 'news',
      _ => 'articles',
    };

    /// для постов в конце пути добавляется слово "remove"
    final append = switch (source) {
      PublicationSource.post => 'remove/',
      _ => '',
    };

    final path = '/v2/$sourcePath/$id/bookmarks/$append';

    /// для новостей и статей используется DELETE, а для постов используется POST
    final response = await switch (source) {
      PublicationSource.post => _siteClient.post(path),
      _ => _siteClient.delete(path),
    };

    if (response.data['ok'] != true) {
      throw const ValueException(.publicationOperationFailed);
    }

    return true;
  }

  @override
  Future<MostReadingResponse> fetchMostReading() async {
    final response = await _siteClient.get('/v2/articles/most-reading');

    return MostReadingResponse.fromMap(response.data);
  }

  @override
  Future<PublicationVoteResponse> voteUp(String publicationId) async {
    final response = await _siteClient.post(
      '/v2/articles/$publicationId/votes/up',
      body: {},
    );

    return PublicationVoteResponse.fromJson(response.data);
  }

  @override
  Future<PublicationVoteResponse> voteDown(String publicationId) async {
    final response = await _siteClient.post(
      '/v2/articles/$publicationId/votes/down',
      body: {},
    );

    return PublicationVoteResponse.fromJson(response.data);
  }
}
