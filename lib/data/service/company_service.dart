part of 'service.dart';

abstract interface class CompanyService {
  Future<CompanyListResponse> fetchAll({
    required int page,
    required String langUI,
    required String langArticles,
  });

  Future<Map<String, dynamic>> fetchCard(
    String alias, {
    required String langUI,
    required String langArticles,
  });

  Future<void> toggleSubscription({required String alias});
}

@LazySingleton(as: CompanyService)
class CompanyServiceImpl implements CompanyService {
  const CompanyServiceImpl({
    @Named('mobileClient') required HttpClient mobileClient,
    @Named('siteClient') required HttpClient siteClient,
  }) : _mobileClient = mobileClient,
       _siteClient = siteClient;

  final HttpClient _mobileClient;
  final HttpClient _siteClient;

  @override
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
    } on AppException {
      rethrow;
    } catch (e) {
      throw FetchException();
    }
  }

  @override
  Future<Map<String, dynamic>> fetchCard(
    String alias, {
    required String langUI,
    required String langArticles,
  }) async {
    try {
      var params = Params(langUI: langUI, langArticles: langArticles);
      final queryString = params.toQueryString();
      final response = await _mobileClient.get(
        '/companies/$alias/card/?$queryString',
      );

      return response.data;
    } on AppException {
      rethrow;
    } catch (e) {
      throw FetchException();
    }
  }

  @override
  Future<void> toggleSubscription({required String alias}) async {
    try {
      await _siteClient.post('/v2/companies/$alias/subscription', body: {});
    } on AppException {
      rethrow;
    } catch (e) {
      throw FetchException();
    }
  }
}
