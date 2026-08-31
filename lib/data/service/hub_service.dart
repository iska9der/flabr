import 'package:injectable/injectable.dart';

import '../../core/component/http/http.dart';
import '../model/hub/hub.dart';
import '../model/query_params_model.dart';

abstract interface class HubService {
  Future<HubListResponse> fetchAll({required int page});

  Future<HubProfile> fetchProfile(String alias);

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
    final params = QueryParams(page: page.toString()).toMap();
    final response = await _mobileClient.get('/hubs', queryParams: params);

    return HubListResponse.fromMap(response.data);
  }

  @override
  Future<HubProfile> fetchProfile(String alias) async {
    final response = await _mobileClient.get('/hubs/$alias/profile');

    return HubProfile.fromMap(response.data);
  }

  @override
  Future<void> toggleSubscription({required String alias}) async {
    await _siteClient.post('/v2/hubs/$alias/subscription', body: {});
  }
}
