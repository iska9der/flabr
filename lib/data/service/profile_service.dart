import 'package:injectable/injectable.dart';

import '../../core/component/http/http.dart';
import '../exception/exception.dart';
import '../model/user/user.dart';

abstract interface class ProfileService {
  Future<UserMe?> fetchMe();

  Future<UserUpdates> fetchUpdates();
}

@Singleton(as: ProfileService)
class ProfileServiceImpl implements ProfileService {
  const ProfileServiceImpl({
    @Named('siteClient') required HttpClient siteClient,
  }) : _siteClient = siteClient;

  final HttpClient _siteClient;

  @override
  Future<UserMe?> fetchMe() async {
    try {
      final response = await _siteClient.get('/v2/me');

      if (response.data == null) {
        return null;
      }

      return UserMe.fromMap(response.data);
    } catch (e, trace) {
      Error.throwWithStackTrace(const FetchException(), trace);
    }
  }

  @override
  Future<UserUpdates> fetchUpdates() async {
    try {
      final response = await _siteClient.get('/v2/me/updates');

      return UserUpdates.fromJson(response.data);
    } catch (e, trace) {
      Error.throwWithStackTrace(const FetchException(), trace);
    }
  }
}
