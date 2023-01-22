import '../../common/profile_subscribe/repository/subscription_repository.dart';
import '../service/hub_service.dart';

class HubSubscriptionRepository implements SubscriptionRepository {
  HubSubscriptionRepository(HubService service) : _service = service;

  final HubService _service;

  @override
  Future<void> toggleSubscription({required String alias}) async {
    await _service.toggleSubscription(alias: alias);
  }
}
