part of 'service.dart';

abstract interface class HubService {
  Future<HubListResponse> fetchAll({
    required int page,
    required String langUI,
    required String langArticles,
  });

  Future<Map<String, dynamic>> fetchProfile(
    String alias, {
    required String langUI,
    required String langArticles,
  });

  Future<void> toggleSubscription({required String alias});
}

@LazySingleton(as: HubService)
class HubServiceImpl implements HubService {
  const HubServiceImpl({
    @Named('mobileClient') required HttpClient mobileClient,
    @Named('siteClient') required HttpClient siteClient,
  }) : _mobileClient = mobileClient,
       _siteClient = siteClient;

  final HttpClient _mobileClient;
  final HttpClient _siteClient;

  @override
  Future<HubListResponse> fetchAll({
    required int page,
    required String langUI,
    required String langArticles,
  }) async {
    try {
      var params = QueryParams(
        page: page.toString(),
        langUI: langUI,
        langArticles: langArticles,
      );
      final queryString = params.toQueryString();
      final response = await _mobileClient.get('/hubs/?$queryString');

      return HubListResponse.fromMap(response.data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw FetchException();
    }
  }

  @override
  Future<Map<String, dynamic>> fetchProfile(
    String alias, {
    required String langUI,
    required String langArticles,
  }) async {
    try {
      var params = QueryParams(langUI: langUI, langArticles: langArticles);
      final queryString = params.toQueryString();
      final response = await _mobileClient.get(
        '/hubs/$alias/profile?$queryString',
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
      await _siteClient.post('/v2/hubs/$alias/subscription', body: {});
    } on AppException {
      rethrow;
    } catch (e) {
      throw FetchException();
    }
  }
}
