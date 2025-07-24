import 'package:injectable/injectable.dart';

import '../model/user/user.dart';
import '../service/service.dart';

@Singleton()
class ProfileRepository {
  ProfileRepository(ProfileService service) : _service = service;

  final ProfileService _service;

  Future<UserMe?> fetchMe() async {
    final raw = await _service.fetchMe();

    if (raw == null) {
      return null;
    }

    return UserMe.fromMap(raw);
  }

  Future<UserUpdates> fetchUpdates() async {
    final map = await _service.fetchUpdates();

    final model = UserUpdates.fromJson(map);

    return model;
  }
}
