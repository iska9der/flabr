import '../../../common/exception/displayable_exception.dart';
import '../../../common/exception/fetch_exception.dart';
import '../../../component/http/http_client.dart';
import '../model/network/search_params.dart';
import '../model/search_target.dart';

class SearchService {
  const SearchService(HttpClient client) : _mobileClient = client;

  final HttpClient _mobileClient;

  Future fetch({
    required String langUI,
    required String langArticles,
    required String query,
    required SearchTarget target,
    required String order,
    required int page,
  }) async {
    try {
      final params = SearchParamsFactory.from(
        langUI: langUI,
        langArticles: langArticles,
        query: query,
        target: target,
        order: order,
        page: page,
      );

      final queryString = params.toQueryString();
      final response = await _mobileClient.get(queryString);

      return response.data;
    } on DisplayableException {
      rethrow;
    } catch (e) {
      throw FetchException();
    }
  }
}
