import '../../../common/exception/displayable_exception.dart';
import '../../../common/exception/fetch_exception.dart';
import '../../../common/model/network/params.dart';
import '../../../component/http/http_client.dart';
import '../model/network/hub_list_response.dart';

class HubRepository {
  const HubRepository(HttpClient client) : _client = client;

  final HttpClient _client;

  Future<HubListResponse> fetchAll({
    required int page,
    required String langUI,
    required String langArticles,
  }) async {
    try {
      var params = Params(
        page: page.toString(),
        langUI: langUI,
        langArticles: langArticles,
      );
      final queryString = params.toQueryString();
      final response = await _client.get('/hubs/?$queryString');

      return HubListResponse.fromMap(response.data);
    } on DisplayableException {
      rethrow;
    } catch (e) {
      throw FetchException();
    }
  }

  Future<Map<String, dynamic>> fetchProfile(
    String alias, {
    required String langUI,
    required String langArticles,
  }) async {
    try {
      var params = Params(
        langUI: langUI,
        langArticles: langArticles,
      );
      final queryString = params.toQueryString();
      final response = await _client.get('/hubs/$alias/profile?$queryString');

      return response.data;
    } on DisplayableException {
      rethrow;
    } catch (e) {
      throw FetchException();
    }
  }
}
