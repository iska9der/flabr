import '../../common/profile_subscribe/repository/subscription_repository.dart';
import '../service/user_service.dart';

class UserSubscriptionRepository implements SubscriptionRepository {
  UserSubscriptionRepository(UserService service) : _service = service;

  final UserService _service;

  @override
  Future<void> toggleSubscription({required String alias}) async {
    await _service.toggleSubscription(alias: alias);
  }
}
