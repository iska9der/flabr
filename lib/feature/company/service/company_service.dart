import '../../../common/exception/displayable_exception.dart';
import '../../../common/exception/fetch_exception.dart';
import '../../../common/model/network/params.dart';
import '../../../component/http/http_client.dart';
import '../model/network/company_list_params.dart';
import '../model/network/company_list_response.dart';

class CompanyService {
  const CompanyService({
    required HttpClient mobileClient,
    required HttpClient siteClient,
  })  : _mobileClient = mobileClient,
        _siteClient = siteClient;

  final HttpClient _mobileClient;
  final HttpClient _siteClient;

  Future<CompanyListResponse> fetchAll({
    required int page,
    required String langUI,
    required String langArticles,
  }) async {
    try {
      var params = CompanyListParams(
        page: page.toString(),
        langUI: langUI,
        langArticles: langArticles,
      );
      final queryString = params.toQueryString();
      final response = await _mobileClient.get(queryString);

      return CompanyListResponse.fromMap(response.data);
    } on DisplayableException {
      rethrow;
    } catch (e) {
      throw FetchException();
    }
  }

  Future<Map<String, dynamic>> fetchCard(
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
      final response =
          await _mobileClient.get('/companies/$alias/card/?$queryString');

      return response.data;
    } on DisplayableException {
      rethrow;
    } catch (e) {
      throw FetchException();
    }
  }

  Future<void> toggleSubscription({required String alias}) async {
    try {
      await _siteClient.post(
        '/v2/hubs/$alias/subscription',
        body: {},
      );
    } on DisplayableException {
      rethrow;
    } catch (e) {
      throw FetchException();
    }
  }
}
