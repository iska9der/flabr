import '../../../common/exception/displayable_exception.dart';
import '../../../common/exception/fetch_exception.dart';
import '../../../common/model/make_request/make_request.dart';
import '../../../common/model/make_request/request_params.dart';
import '../../../components/http/http_client.dart';
import '../model/request/article_params.dart';
import '../model/sort/period_enum.dart';
import '../model/sort/sort_enum.dart';

class ArticleRepository {
  const ArticleRepository(this._client);

  final HttpClient _client;

  Future<Map<String, dynamic>> fetchAll({
    required SortEnum sort,
    required String page,
    PeriodEnum period = PeriodEnum.daily,
    String score = "0",
  }) async {
    try {
      final body = MakeRequest(
        method: 'articles',
        requestParams: RequestParams(
          params: ArticlesParams(
            sort: sort,
            period: sort == SortEnum.date ? PeriodEnum.daily : null,
            score: sort == SortEnum.rating ? score : null,
            page: page,
          ),
        ),
      );

      final map = body.toMap();
      final response = await _client.post('makeRequest', body: map);

      return response.data;
    } on DisplayableException {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchNews() async {
    try {
      final body = MakeRequest(
        method: 'articles',
        requestParams: RequestParams(params: ArticlesParams(news: "true")),
      );

      final map = body.toMap();
      final response = await _client.post('makeRequest', body: map);

      return response.data;
    } catch (e) {
      throw FetchException();
    }
  }

  /// todo: unimplemented
  Future<Map<String, dynamic>> fetchFeed({
    required SortEnum sort,
    required String page,
  }) async {
    return fetchAll(sort: sort, page: page);
  }
}
