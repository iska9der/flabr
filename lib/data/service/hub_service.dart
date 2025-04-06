import 'package:injectable/injectable.dart';

import '../../core/component/http/http.dart';
import '../exception/exception.dart';
import '../model/hub/hub.dart';
import '../model/query_params_model.dart';

abstract interface class HubService {
  Future<HubListResponse> fetchAll({required int page});

  Future<Map<String, dynamic>> fetchProfile(String alias);

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
  Future<HubListResponse> fetchAll({required int page}) async {
    try {
      var params = QueryParams(page: page.toString()).toMap();
      final response = await _mobileClient.get('/hubs', queryParams: params);

      return HubListResponse.fromMap(response.data);
    } on AppException {
      rethrow;
    } catch (_, stackTrace) {
      Error.throwWithStackTrace(const FetchException(), stackTrace);
    }
  }

  @override
  Future<Map<String, dynamic>> fetchProfile(String alias) async {
    try {
      final response = await _mobileClient.get('/hubs/$alias/profile');

      return response.data;
    } on AppException {
      rethrow;
    } catch (_, stackTrace) {
      Error.throwWithStackTrace(const FetchException(), stackTrace);
    }
  }

  @override
  Future<void> toggleSubscription({required String alias}) async {
    try {
      await _siteClient.post('/v2/hubs/$alias/subscription', body: {});
    } on AppException {
      rethrow;
    } catch (_, stackTrace) {
      Error.throwWithStackTrace(const FetchException(), stackTrace);
    }
  }
}
