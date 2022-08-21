import '../../../common/exception/displayable_exception.dart';
import '../../../common/exception/fetch_exception.dart';
import '../../../common/model/make_request/make_request.dart';
import '../../../common/model/make_request/request_params.dart';
import '../../../component/http/http_client.dart';
import '../model/network/article_params.dart';
import '../model/network/article_response.dart';
import '../model/sort/date_period_enum.dart';
import '../model/sort/sort_enum.dart';

class ArticleRepository {
  const ArticleRepository(this._baseClient, this._proxyClient);

  final HttpClient _baseClient;
  final HttpClient _proxyClient;

  Future<ArticleResponse> fetchAll({
    required SortEnum sort,
    required String page,
    required DatePeriodEnum period,
    required String score,
  }) async {
    try {
      final body = MakeRequest(
        method: 'articles',
        requestParams: RequestParams(
          params: ArticlesParams(
            sort: sort,
            period: sort == SortEnum.date ? period : null,
            score: sort == SortEnum.rating ? score : null,
            page: page,
          ),
        ),
      );

      final map = body.toMap();
      final response = await _proxyClient.post(
        '/makeRequest',
        body: map,
      );

      return ArticleResponse.fromMap(response.data);
    } on DisplayableException {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchNews() async {
    try {
      final body = MakeRequest(
        method: 'articles',
        requestParams: RequestParams(params: ArticlesParams(news: 'true')),
      );

      final map = body.toMap();
      final response = await _proxyClient.post(
        '/makeRequest',
        body: map,
      );

      return response.data;
    } catch (e) {
      throw FetchException();
    }
  }

  /// todo: unimplemented
  void fetchFeed() {}

  Future<Map<String, dynamic>> fetchById(String id) async {
    try {
      final response = await _baseClient.get('/articles/$id');

      return response.data;
    } catch (e) {
      throw FetchException();
    }
  }
}
