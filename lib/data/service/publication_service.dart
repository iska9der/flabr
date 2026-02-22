import 'package:dio/dio.dart';
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
  Future<Map<String, dynamic>> fetchCounters();

  Future<Map<String, dynamic>> fetchArticleById(String id);

  Future<Map<String, dynamic>> fetchPostById(String id);

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
    @Named('mobileClient') required HttpClient mobileClient,
    @Named('siteClient') required HttpClient siteClient,
  }) : _mobileClient = mobileClient,
       _siteClient = siteClient;

  final HttpClient _mobileClient;
  final HttpClient _siteClient;

  @override
  Future<Map<String, dynamic>> fetchCounters() async {
    try {
      final response = await _mobileClient.get('/feed/counters');

      return response.data;
    } catch (_, trace) {
      Error.throwWithStackTrace(const FetchException(), trace);
    }
  }

  @override
  Future<Map<String, dynamic>> fetchArticleById(String id) async {
    try {
      final response = await _mobileClient.get('/articles/$id/');

      return response.data;
    } catch (_, trace) {
      Error.throwWithStackTrace(const FetchException(), trace);
    }
  }

  @override
  Future<Map<String, dynamic>> fetchPostById(String id) async {
    try {
      final response = await _mobileClient.get('/threads/$id/');

      return response.data;
    } catch (_, trace) {
      Error.throwWithStackTrace(const FetchException(), trace);
    }
  }

  @override
  Future<ListResponse<Publication>> fetchFeed({
    required String page,
    required String score,
    required List<String> types,
  }) async {
    try {
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
    } on AppException {
      rethrow;
    } catch (_, trace) {
      Error.throwWithStackTrace(const FetchException(), trace);
    }
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
    try {
      final flowStr = (flow == .all) ? null : flow.name;

      final params = switch (section) {
        .post => PublicationPostListParams(
          page: page,
          flow: flowStr,
          sort: sort.postValue,
          period: sort == .byBest ? period.value : null,
          score: score.value,
        ),
        _ => PublicationListParams(
          page: page,
          flow: flowStr,
          news: section == .news,

          /// если мы находимся не во "Все потоки", в значение sort, по завету
          /// костыльного api хабра, нужно передавать значение 'all'
          sort: flow == .all ? sort.value : 'all',
          period: sort == .byBest ? period.value : null,
          score: score.value,
        ),
      }.toMap();

      final response = await _siteClient.get(
        '/v2/articles/',
        queryParams: params,
      );

      return switch (section) {
        .post => PublicationPostListResponse.fromMap(response.data),
        _ => PublicationCommonListResponse.fromMap(response.data),
      };
    } on AppException {
      rethrow;
    } catch (_, trace) {
      Error.throwWithStackTrace(const FetchException(), trace);
    }
  }

  @override
  Future<ListResponse<Publication>> fetchHubArticles({
    required String hub,
    required Sort sort,
    required FilterOption period,
    required FilterOption score,
    required String page,
  }) async {
    try {
      final params = PublicationListParams(
        page: page,
        sort: 'all',
        period: sort == Sort.byBest ? period.value : null,
        score: score.value,
      ).toMap();

      params.addAll({'hub': hub});

      final response = await _mobileClient.get(
        '/articles/',
        queryParams: params,
      );

      return PublicationCommonListResponse.fromMap(response.data);
    } on AppException {
      rethrow;
    } catch (_, trace) {
      Error.throwWithStackTrace(const FetchException(), trace);
    }
  }

  @override
  Future<ListResponse<Publication>> fetchUserPublications({
    required String user,
    required String page,
    required UserPublicationType type,
  }) async {
    try {
      final params = PublicationListParams(page: page).toMap();

      final typeQuery = switch (type) {
        .articles => null,
        .posts => {'posts': 'true'},
        .news => {'news': 'true'},
      };

      params.addAll({'user': user});
      if (typeQuery != null) {
        params.addAll(typeQuery);
      }

      final response = await _mobileClient.get(
        '/articles/',
        queryParams: params,
      );

      return switch (type) {
        .posts => PublicationPostListResponse.fromMap(response.data),
        _ => PublicationCommonListResponse.fromMap(response.data),
      };
    } on AppException {
      rethrow;
    } catch (_, trace) {
      Error.throwWithStackTrace(const FetchException(), trace);
    }
  }

  @override
  Future<ListResponse<Publication>> fetchUserBookmarks({
    required String user,
    required String page,
    required UserBookmarksType type,
  }) async {
    try {
      final params = PublicationListParams(page: page).toMap();

      final typeQuery = switch (type) {
        UserBookmarksType.articles => {'user_bookmarks': 'true'},
        UserBookmarksType.posts => {'user_bookmarks_posts': 'true'},
        UserBookmarksType.news => {'user_bookmarks_news': 'true'},
        UserBookmarksType.comments => throw const ValueException(
          'Вы не туда попали...',
        ),
      };

      params.addAll({'user': user, ...typeQuery});

      final response = await _mobileClient.get(
        '/articles/',
        queryParams: params,
      );

      return switch (type) {
        .posts => PublicationPostListResponse.fromMap(response.data),
        _ => PublicationCommonListResponse.fromMap(response.data),
      };
    } on AppException {
      rethrow;
    } catch (_, trace) {
      Error.throwWithStackTrace(const FetchException(), trace);
    }
  }

  @override
  Future<CommentListResponse> fetchComments({
    required String articleId,
    required PublicationSource source,
  }) async {
    try {
      final firstPathPart = switch (source) {
        .post => 'threads',
        _ => 'articles',
      };

      final response = await _mobileClient.get(
        '/$firstPathPart/$articleId/comments/',
      );

      return .fromMap(response.data);
    } on AppException {
      rethrow;
    } on DioException catch (e, trace) {
      Error.throwWithStackTrace(
        CommentsListException.fromDioException(e),
        trace,
      );
    } catch (_, trace) {
      Error.throwWithStackTrace(const FetchException(), trace);
    }
  }

  @override
  Future<bool> addToBookmark({
    required String id,
    required PublicationSource source,
  }) async {
    try {
      final sourcePath = switch (source) {
        .post => 'threads',
        .news => 'news',
        _ => 'articles',
      };

      /// для постов в конце пути добавляется слово "add"
      final append = switch (source) {
        .post => 'add/',
        _ => '',
      };

      final response = await _siteClient.post(
        '/v2/$sourcePath/$id/bookmarks/$append',
        body: {},
      );

      if (response.data['ok'] != true) {
        throw const ValueException('Не удалось!');
      }

      return true;
    } on AppException {
      rethrow;
    } catch (e, trace) {
      Error.throwWithStackTrace(const FetchException(), trace);
    }
  }

  @override
  Future<bool> removeFromBookmark({
    required String id,
    required PublicationSource source,
  }) async {
    try {
      final sourcePath = switch (source) {
        .post => 'threads',
        .news => 'news',
        _ => 'articles',
      };

      /// для постов в конце пути добавляется слово "remove"
      final append = switch (source) {
        .post => 'remove/',
        _ => '',
      };

      final path = '/v2/$sourcePath/$id/bookmarks/$append';

      /// для новостей и статей используется DELETE, а для постов используется POST
      final response = await switch (source) {
        .post => _siteClient.post(path),
        _ => _siteClient.delete(path),
      };

      if (response.data['ok'] != true) {
        throw const ValueException('Не удалось!');
      }

      return true;
    } on AppException {
      rethrow;
    } catch (_, trace) {
      Error.throwWithStackTrace(const FetchException(), trace);
    }
  }

  @override
  Future<MostReadingResponse> fetchMostReading() async {
    try {
      final response = await _mobileClient.get('/articles/most-reading');

      return .fromMap(response.data);
    } on AppException {
      rethrow;
    } catch (_, trace) {
      Error.throwWithStackTrace(const FetchException(), trace);
    }
  }

  @override
  Future<PublicationVoteResponse> voteUp(String publicationId) async {
    try {
      final response = await _siteClient.post(
        '/v2/articles/$publicationId/votes/up',
        body: {},
      );

      return .fromJson(response.data);
    } catch (_, trace) {
      Error.throwWithStackTrace(const FetchException(), trace);
    }
  }

  @override
  Future<PublicationVoteResponse> voteDown(String publicationId) async {
    try {
      final response = await _siteClient.post(
        '/v2/articles/$publicationId/votes/down',
        body: {},
      );

      return .fromJson(response.data);
    } catch (_, trace) {
      Error.throwWithStackTrace(const FetchException(), trace);
    }
  }
}
