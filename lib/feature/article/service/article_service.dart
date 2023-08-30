import 'package:dio/dio.dart';

import '../../../common/exception/displayable_exception.dart';
import '../../../common/exception/fetch_exception.dart';
import '../../../common/exception/value_exception.dart';
import '../../../common/model/network/params.dart';
import '../../../component/http/http_client.dart';
import '../../comment/model/network/comment_list_exception.dart';
import '../../comment/model/network/comment_list_params.dart';
import '../../comment/model/network/comment_list_response.dart';
import '../model/article_type.dart';
import '../model/flow_enum.dart';
import '../model/network/article_list_params.dart';
import '../model/network/article_list_response.dart';
import '../model/sort/date_period_enum.dart';
import '../model/sort/sort_enum.dart';

class ArticleService {
  const ArticleService(
      {required HttpClient mobileClient, required HttpClient siteClient})
      : _mobileClient = mobileClient,
        _siteClient = siteClient;

  final HttpClient _mobileClient;
  final HttpClient _siteClient;

  Future<Map<String, dynamic>> fetchById(
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
    } catch (e) {
      throw FetchException();
    }
  }

  Future<ArticleListResponse> fetchFlowArticles({
    required String langUI,
    required String langArticles,
    required ArticleType type,
    required FlowEnum flow,
    required SortEnum sort,
    required String page,
    required DatePeriodEnum period,
    required String score,
  }) async {
    try {
      final params = ArticleListParams(
        langArticles: langArticles,
        langUI: langUI,
        flow: flow == FlowEnum.all ? null : flow.name,
        news: type == ArticleType.news,
        custom: flow == FlowEnum.feed ? 'true' : null,

        /// если мы находимся не во "Все потоки", в значение sort, по завету
        /// костыльного api хабра, нужно передавать значение 'all'
        sort: flow == FlowEnum.all ? sort.value : 'all',
        period: sort == SortEnum.byBest ? period.name : null,
        score: sort == SortEnum.byNew ? score : null,
        page: page,
      );

      final queryString = params.toQueryString();
      final response = await _mobileClient.get('/articles/?$queryString');

      return ArticleListResponse.fromMap(
        response.data,
      );
    } on DisplayableException {
      rethrow;
    } on DioException {
      throw FetchException();
    }
  }

  Future<ArticleListResponse> fetchHubArticles({
    required String langUI,
    required String langArticles,
    required String hub,
    required SortEnum sort,
    required DatePeriodEnum period,
    required String score,
    required String page,
  }) async {
    try {
      final params = ArticleListParams(
        langArticles: langArticles,
        langUI: langUI,
        sort: 'all',
        period: sort == SortEnum.byBest ? period.name : null,
        score: sort == SortEnum.byNew ? score : null,
        page: page,
      );

      final queryString = params.toQueryString();
      final response = await _mobileClient.get(
        '/articles/?hub=$hub&$queryString',
      );

      return ArticleListResponse.fromMap(response.data);
    } on DisplayableException {
      rethrow;
    } on DioException {
      throw FetchException();
    }
  }

  Future<ArticleListResponse> fetchUserArticles({
    required String langUI,
    required String langArticles,
    required String user,
    required SortEnum sort,
    required DatePeriodEnum period,
    required String score,
    required String page,
  }) async {
    try {
      final params = ArticleListParams(
        langArticles: langArticles,
        langUI: langUI,
        page: page,
      );

      final queryString = params.toQueryString();
      final response = await _mobileClient.get(
        '/articles/?user=$user&$queryString',
      );

      return ArticleListResponse.fromMap(response.data);
    } on DisplayableException {
      rethrow;
    } on DioException {
      throw FetchException();
    }
  }

  Future<ArticleListResponse> fetchUserBookmarks({
    required String langUI,
    required String langArticles,
    required String user,
    required String page,
  }) async {
    try {
      final params = ArticleListParams(
        langArticles: langArticles,
        langUI: langUI,
        page: page,
      );

      final queryString = params.toQueryString();
      final response = await _mobileClient.get(
        '/articles/?user=$user&user_bookmarks=true&$queryString',
      );

      return ArticleListResponse.fromMap(response.data);
    } on DisplayableException {
      rethrow;
    } on DioException {
      throw FetchException();
    }
  }

  Future<CommentListResponse> fetchComments({
    required String articleId,
    required String langUI,
    required String langArticles,
  }) async {
    try {
      final params = CommentListParams(
        articleId: articleId,
        langArticles: langArticles,
        langUI: langUI,
      );

      final queryString = params.toQueryString();
      final response = await _mobileClient.get(queryString);

      return CommentListResponse.fromMap(response.data);
    } on DisplayableException {
      rethrow;
    } on DioException catch (e) {
      throw CommentsListException.fromDioException(e);
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
    } on DioException {
      throw FetchException();
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
    } on DioException {
      throw FetchException();
    }
  }
}
