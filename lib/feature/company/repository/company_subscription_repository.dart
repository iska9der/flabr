import '../../common/profile_subscribe/repository/subscription_repository.dart';
import '../service/company_service.dart';

class CompanySubscriptionRepository extends SubscriptionRepository {
  CompanySubscriptionRepository(CompanyService service) : _service = service;

  final CompanyService _service;

  @override
  Future<void> toggleSubscription({required String alias}) async {
    await _service.toggleSubscription(alias: alias);
  }
}
