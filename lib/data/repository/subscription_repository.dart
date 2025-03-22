import 'dart:async';

import '../service/service.dart';

abstract interface class SubscriptionRepository {
  toggleSubscription({required String alias});
}

class CompanySubscriptionRepository extends SubscriptionRepository {
  CompanySubscriptionRepository(CompanyService service) : _service = service;

  final CompanyService _service;

  @override
  Future<void> toggleSubscription({required String alias}) async {
    await _service.toggleSubscription(alias: alias);
  }
}

class HubSubscriptionRepository implements SubscriptionRepository {
  HubSubscriptionRepository(HubService service) : _service = service;

  final HubService _service;

  @override
  Future<void> toggleSubscription({required String alias}) async {
    await _service.toggleSubscription(alias: alias);
  }
}

class UserSubscriptionRepository implements SubscriptionRepository {
  UserSubscriptionRepository(UserService service) : _service = service;

  final UserService _service;

  @override
  Future<void> toggleSubscription({required String alias}) async {
    await _service.toggleSubscription(alias: alias);
  }
}
