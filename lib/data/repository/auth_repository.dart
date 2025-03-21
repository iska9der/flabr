part of 'repository.dart';

@Singleton()
class AuthRepository {
  AuthRepository(AuthService service) : _service = service;

  final AuthService _service;

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
