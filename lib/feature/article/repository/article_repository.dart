import 'package:flabr/common/model/make_request/make_request.dart';
import 'package:flabr/common/model/make_request/params.dart';
import 'package:flabr/common/model/make_request/request_params.dart';

import '../../../common/exception/fetch_exception.dart';
import '../../../components/http/http_client.dart';

class ArticleRepository {
  const ArticleRepository(this._client);

  final HttpClient _client;

  Future<Map<String, dynamic>> fetchAll() async {
    try {
      const body = MakeRequest(
        method: 'articles/most-reading',
        requestParams: RequestParams(),
      );

      final map = body.toMap();
      final response = await _client.post('makeRequest', body: map);

      return response.data;
    } catch (e) {
      throw FetchException();
    }
  }

  Future<Map<String, dynamic>> fetchNews() async {
    try {
      const body = MakeRequest(
        method: 'articles',
        requestParams: RequestParams(params: Params(news: "true")),
      );

      final map = body.toMap();
      final response = await _client.post('makeRequest', body: map);

      return response.data;
    } catch (e) {
      throw FetchException();
    }
  }
}
