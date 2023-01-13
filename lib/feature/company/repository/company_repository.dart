import '../../../common/exception/displayable_exception.dart';
import '../../../common/exception/fetch_exception.dart';
import '../../../common/model/network/params.dart';
import '../../../component/http/http_client.dart';
import '../model/network/company_list_response.dart';

class CompanyRepository {
  const CompanyRepository({
    required HttpClient mobileClient,
  }) : _mobileClient = mobileClient;

  final HttpClient _mobileClient;

  Future<CompanyListResponse> fetchAll({
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
      final response = await _mobileClient.get('/companies/?$queryString');

      return CompanyListResponse.fromMap(response.data);
    } on DisplayableException {
      rethrow;
    } catch (e) {
      throw FetchException();
    }
  }
}
