import '../../../common/exception/displayable_exception.dart';
import '../../../common/exception/fetch_exception.dart';
import '../../../common/model/network/make_request.dart';
import '../../../common/model/network/request_params.dart';
import '../../../component/http/http_client.dart';
import '../model/network/articles_params.dart';
import '../model/network/articles_response.dart';
import '../model/sort/date_period_enum.dart';
import '../model/sort/sort_enum.dart';

class ArticlesRepository {
  const ArticlesRepository(this._baseClient, this._proxyClient);

  final HttpClient _baseClient;
  final HttpClient _proxyClient;

  Future<ArticlesResponse> fetchAll({
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

      return ArticlesResponse.fromMap(response.data);
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
