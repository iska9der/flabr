import 'package:injectable/injectable.dart';

import '../../core/component/http/http.dart';
import '../model/user/user.dart';

abstract interface class ProfileService {
  Future<UserMe?> fetchMe();

  Future<UserUpdates> fetchUpdates();
}

@Singleton(as: ProfileService)
class ProfileServiceImpl implements ProfileService {
  const ProfileServiceImpl({
    @Named('siteClient') required this._siteClient,
  });

  final HttpClient _siteClient;

  @override
  Future<UserMe?> fetchMe() async {
    final response = await _siteClient.get('/v2/me');
    if (response.data == null) {
      return null;
    }

    return UserMe.fromMap(response.data);
  }

  @override
  Future<UserUpdates> fetchUpdates() async {
    final response = await _siteClient.get('/v2/me/updates');

    return UserUpdates.fromJson(response.data);
  }
}
