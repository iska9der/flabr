import 'package:dio/dio.dart';

import '../../../common/exception/displayable_exception.dart';
import '../../../common/exception/fetch_exception.dart';
import '../../../common/exception/value_exception.dart';
import '../../../common/model/network/list_response.dart';
import '../../../common/model/network/params.dart';
import '../../../component/http/http_client.dart';
import '../../user/model/user_bookmarks_type.dart';
import '../../user/model/user_publication_type.dart';
import '../model/comment/network/comment_list_exception.dart';
import '../model/comment/network/comment_list_params.dart';
import '../model/comment/network/comment_list_response.dart';
import '../model/flow_enum.dart';
import '../model/network/feed_list_params.dart';
import '../model/network/most_reading_response.dart';
import '../model/network/post_list_params.dart';
import '../model/network/post_list_response.dart';
import '../model/network/publication_list_params.dart';
import '../model/network/publication_list_response.dart';
import '../model/publication_type.dart';
import '../model/sort/date_period_enum.dart';
import '../model/sort/sort_enum.dart';
import '../model/source/publication_source.dart';

class PublicationService {
  const PublicationService({
    required HttpClient mobileClient,
    required HttpClient siteClient,
  })  : _mobileClient = mobileClient,
        _siteClient = siteClient;

  final HttpClient _mobileClient;
  final HttpClient _siteClient;

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

  Future<ListResponse> fetchFeed({
    required String langUI,
    required String langArticles,
    required String page,
  }) async {
    try {
      final params = FeedListParams(
        langArticles: langArticles,
        langUI: langUI,
        page: page,
      );
      final queryString = params.toQueryString();
      final response = await _mobileClient.get(
        '/articles/?myFeed=true&$queryString',
      );

      return PublicationListResponse.fromMap(response.data);
    } on DisplayableException {
      rethrow;
    } catch (e, trace) {
      Error.throwWithStackTrace(FetchException(), trace);
    }
  }

  Future<ListResponse> fetchFlowArticles({
    required String langUI,
    required String langArticles,
    required PublicationType type,
    required FlowEnum flow,
    required SortEnum sort,
    required String page,
    required DatePeriodEnum period,
    required String score,
  }) async {
    try {
      final flowStr = (flow == FlowEnum.all) ? null : flow.name;

      final params = switch (type) {
        PublicationType.post => PostListParams(
            langArticles: langArticles,
            langUI: langUI,
            page: page,
            flow: flowStr,
            sort: sort.postValue,
            period: sort == SortEnum.byBest ? period.name : null,
            score: score,
          ),
        _ => PublicationListParams(
            langArticles: langArticles,
            langUI: langUI,
            page: page,
            flow: flowStr,
            news: type == PublicationType.news,

            /// если мы находимся не во "Все потоки", в значение sort, по завету
            /// костыльного api хабра, нужно передавать значение 'all'
            sort: flow == FlowEnum.all ? sort.value : 'all',
            period: sort == SortEnum.byBest ? period.name : null,
            score: score,
          ),
      };
      final queryString = params.toQueryString();
      final response = await _mobileClient.get('/articles/?$queryString');

      return switch (type) {
        PublicationType.post => PostListResponse.fromMap(response.data),
        _ => PublicationListResponse.fromMap(response.data),
      } as ListResponse;
    } on DisplayableException {
      rethrow;
    } catch (e, trace) {
      Error.throwWithStackTrace(FetchException(), trace);
    }
  }

  Future<PublicationListResponse> fetchHubArticles({
    required String langUI,
    required String langArticles,
    required String hub,
    required SortEnum sort,
    required DatePeriodEnum period,
    required String score,
    required String page,
  }) async {
    try {
      final params = PublicationListParams(
        langArticles: langArticles,
        langUI: langUI,
        page: page,
        sort: 'all',
        period: sort == SortEnum.byBest ? period.name : null,
        score: score,
      );
      final queryString = params.toQueryString();
      final response = await _mobileClient.get(
        '/articles/?hub=$hub&$queryString',
      );

      return PublicationListResponse.fromMap(response.data);
    } on DisplayableException {
      rethrow;
    } catch (e, trace) {
      Error.throwWithStackTrace(FetchException(), trace);
    }
  }

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

      final queryString = params.toQueryString();
      final response = await _mobileClient.get(
        '/articles/?user=$user$typeQuery&$queryString',
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
}
