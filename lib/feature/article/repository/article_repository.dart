import 'package:dio/dio.dart';

import '../../../common/exception/displayable_exception.dart';
import '../../../common/exception/fetch_exception.dart';
import '../../../component/http/http_client.dart';
import '../../comment/model/network/comment_list_params.dart';
import '../../comment/model/network/comment_list_response.dart';
import '../model/article_type.dart';
import '../model/flow_enum.dart';
import '../model/network/article_list_params.dart';
import '../model/network/article_list_response.dart';
import '../model/sort/date_period_enum.dart';
import '../model/sort/sort_enum.dart';

class ArticleRepository {
  const ArticleRepository(this._baseClient);

  final HttpClient _baseClient;

  Future<Map<String, dynamic>> fetchById(String id) async {
    try {
      final response = await _baseClient.get('/articles/$id');

      return response.data;
    } catch (e) {
      throw FetchException();
    }
  }

  Future<ArticleListResponse> fetchByFlow({
    required String langUI,
    required String langArticles,
    required ArticleType type,
    required FlowEnum flow,
    String connectSid = '',
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
      Options? options;
      if (connectSid.isNotEmpty) {
        options = Options(headers: {'Cookie': 'connect_sid=$connectSid'});
      }

      final response = await _baseClient.get(
        '/articles/?$queryString',
        options: options,
      );

      return ArticleListResponse.fromMap(
        response.data,
      );
    } on DisplayableException {
      rethrow;
    } catch (e) {
      throw FetchException();
    }
  }

  Future<ArticleListResponse> fetchByHub({
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
      final response = await _baseClient.get(
        '/articles/?hub=$hub&$queryString',
      );

      return ArticleListResponse.fromMap(response.data);
    } on DisplayableException {
      rethrow;
    } catch (e) {
      throw FetchException();
    }
  }

  fetchByUser({
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
      final response = await _baseClient.get(
        '/articles/?user=$user&$queryString',
      );

      return ArticleListResponse.fromMap(response.data);
    } on DisplayableException {
      rethrow;
    } catch (e) {
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
      final response = await _baseClient.get(queryString);

      return CommentListResponse.fromMap(response.data);
    } on DisplayableException {
      rethrow;
    } catch (e) {
      throw FetchException();
    }
  }
}
