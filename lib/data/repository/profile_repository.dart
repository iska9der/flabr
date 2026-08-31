import 'package:injectable/injectable.dart';

import '../model/user/user.dart';
import '../service/service.dart';

@Singleton()
class ProfileRepository {
  ProfileRepository(ProfileService service) : _service = service;

  final ProfileService _service;

  Future<UserMe?> fetchMe() => _service.fetchMe();

  Future<UserUpdates> fetchUpdates() => _service.fetchUpdates();
}
