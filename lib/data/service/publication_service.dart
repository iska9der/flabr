import 'package:injectable/injectable.dart';

import '../../core/component/http/http.dart';
import '../exception/exception.dart';
import '../model/comment/comment.dart';
import '../model/filter/filter.dart';
import '../model/list_response_model.dart';
import '../model/publication/publication.dart';
import '../model/user/user.dart';

abstract interface class PublicationService {
  Future<PublicationCounters> fetchCounters();

  Future<PublicationCommon> fetchArticleById(String id);

  Future<PublicationPost> fetchPostById(String id);

  Future<ListResponse<Publication>> fetchFeed({
    required String page,
    required FeedFilter filter,
  });

  Future<ListResponse<Publication>> fetchFlowArticles({
    required PublicationFlow flow,
    required FlowFilter filter,
    required String page,
  });

  Future<ListResponse<Publication>> fetchHubArticles({
    required String hub,
    required FlowFilter filter,
    required String page,
  });

  Future<ListResponse<Publication>> fetchUserPublications({
    required String user,
    required String page,
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

@prod
@dev
@test
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
    required FeedFilter filter,
  }) async {
    final response = await _siteClient.get(
      '/v2/articles/',
      queryParams: {
        'queryType': 'feed',
        'page': page,
        'score': filter.score.value.isEmpty ? 'all' : filter.score.value,
        ...filter.criteria.toQuery(personal: true),
      },
    );

    return FeedListResponse.fromMap(response.data);
  }

  @override
  Future<ListResponse<Publication>> fetchFlowArticles({
    required PublicationFlow flow,
    required FlowFilter filter,
    required String page,
  }) async {
    return _fetchArticles(page, filter, {
      'queryType': flow == PublicationFlow.all ? 'articles' : 'flows_new',
      if (flow != PublicationFlow.all) 'flow': flow.alias,
      'sort': flow == PublicationFlow.all ? filter.sort.value : 'all',
    });
  }

  @override
  Future<ListResponse<Publication>> fetchHubArticles({
    required String hub,
    required FlowFilter filter,
    required String page,
  }) => _fetchArticles(page, filter, {
    'queryType': 'hubs',
    'hub': hub,
    'sort': 'all',
  });

  Future<ListResponse<Publication>> _fetchArticles(
    String page,
    FlowFilter filter,
    Map<String, String> source,
  ) async {
    final response = await _siteClient.get(
      '/v2/articles/',
      queryParams: {
        ...source,
        'page': page,
        if (filter.sort == Sort.byBest) 'period': filter.period.value,
        if (filter.sort == Sort.byNew && filter.score.value.isNotEmpty)
          'score': filter.score.value,
        ...filter.criteria.toQuery(),
      },
    );
    return PublicationCommonListResponse.fromMap(response.data);
  }

  @override
  Future<ListResponse<Publication>> fetchUserPublications({
    required String user,
    required String page,
  }) async {
    final response = await _siteClient.get(
      '/v2/articles/',
      queryParams: {
        'queryType': 'users',
        'user': user,
        'page': page,
      },
    );
    return PublicationCommonListResponse.fromMap(response.data);
  }

  @override
  Future<ListResponse<Publication>> fetchUserBookmarks({
    required String user,
    required String page,
    required UserBookmarksType type,
  }) async {
    if (type == UserBookmarksType.comments) {
      throw const ValueException(.wrongPublicationDestination);
    }
    final response = await _siteClient.get(
      '/v2/articles/',
      queryParams: {
        'queryType': 'bookmarks',
        'user_bookmarks': 'true',
        'user': user,
        'page': page,
      },
    );
    return PublicationCommonListResponse.fromMap(response.data);
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
