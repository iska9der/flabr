import '../../../common/exception/displayable_exception.dart';
import '../../../common/exception/fetch_exception.dart';
import '../../../component/http/http_client.dart';
import '../model/article_type.dart';
import '../model/flow_enum.dart';
import '../model/network/article_list_params.dart';
import '../model/network/article_list_response.dart';
import '../model/sort/date_period_enum.dart';
import '../model/sort/sort_enum.dart';

/// todo: [_proxyClient] пока не используется, но, с появлением
/// авторизации, возможно он пригодится
class ArticleRepository {
  const ArticleRepository(this._baseClient, this._proxyClient);

  final HttpClient _baseClient;
  final HttpClient _proxyClient;

  Future<ArticleListResponse> fetchAll({
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
        fl: langArticles,
        hl: langUI,
        flow: flow == FlowEnum.all ? null : flow.name,
        news: type == ArticleType.news,

        /// если мы находимся не во "Все потоки", в значение sort, по завету
        /// костыльного api хабра, нужно передавать значение 'all'
        sort: flow == FlowEnum.all ? sort.value : 'all',
        period: sort == SortEnum.byBest ? period.name : null,
        score: sort == SortEnum.byNew ? score : null,
        page: page,
      );

      final queryString = params.toQueryString();
      final response = await _baseClient.get('/articles/?$queryString');

      return ArticleListResponse.fromMap(
        response.data,
      );
    } on DisplayableException {
      rethrow;
    } catch (e) {
      throw FetchException();
    }
  }

  /// todo: получение моей ленты
  void fetchFeed() {}

  Future<Map<String, dynamic>> fetchById(String id) async {
    try {
      final response = await _baseClient.get('/articles/$id');

      return response.data;
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
        fl: langArticles,
        hl: langUI,
        sort: 'all',
        period: sort == SortEnum.byBest ? period.name : null,
        score: sort == SortEnum.byNew ? score : null,
        page: page,
      );

      final queryString = params.toQueryString();
      final response = await _baseClient.get(
        '/articles/?hub=$hub&$queryString',
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
}
