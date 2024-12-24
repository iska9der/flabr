part of 'part.dart';

abstract interface class AuthService {
  Future<Map<String, dynamic>?> fetchMe();

  Future<Map<String, dynamic>> fetchUpdates();
}

@Singleton(as: AuthService)
class AuthServiceImpl implements AuthService {
  const AuthServiceImpl({
    @Named('siteClient') required HttpClient siteClient,
    @Named('mobileClient') required HttpClient mobileClient,
  })  : _siteClient = siteClient,
        _mobileClient = mobileClient;

  final HttpClient _siteClient;
  final HttpClient _mobileClient;

  @override
  Future<Map<String, dynamic>?> fetchMe() async {
    try {
      final response = await _mobileClient.get('/me');

      return response.data;
    } catch (e) {
      throw FetchException();
    }
  }

  @override
  Future<Map<String, dynamic>> fetchUpdates() async {
    try {
      final response = await _siteClient.get('/v2/me/updates');

      return response.data;
    } catch (e, trace) {
      Error.throwWithStackTrace(FetchException(), trace);
    }
  }
}
