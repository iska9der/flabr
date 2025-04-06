import 'package:injectable/injectable.dart';

import '../model/hub/hub.dart';
import '../service/service.dart';

@LazySingleton()
class HubRepository {
  HubRepository(HubService service) : _service = service;

  final HubService _service;

  Future<HubListResponse> fetchAll({required int page}) async {
    final response = await _service.fetchAll(page: page);

    return response;
  }

  Future<HubProfile> fetchProfile(String alias) async {
    final raw = await _service.fetchProfile(alias);

    return HubProfile.fromMap(raw);
  }
}
