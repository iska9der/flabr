part of 'part.dart';

abstract interface class AuthService {
  Future<Map<String, dynamic>?> fetchMe();

  /// Отправляем запрос на страницу с данными пользователя в заголовке запроса,
  /// чтобы в дальнейшем вытащить из мета тега csrf-token
  Future<String> fetchRawMainPage(String cookie);
}

@Singleton(as: AuthService)
class AuthServiceImpl implements AuthService {
  const AuthServiceImpl({
    @Named('mobileClient') required HttpClient mobileClient,
  }) : _mobileClient = mobileClient;

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
  Future<String> fetchRawMainPage(String cookie) async {
    try {
      final options = Options(headers: {'Cookie': cookie});
      final response = await _mobileClient.get(
        'https://habr.com/ru/conversations',
        options: options,
      );

      return response.data;
    } catch (e) {
      throw FetchException();
    }
  }
}
