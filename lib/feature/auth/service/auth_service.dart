import 'package:dio/dio.dart';

import '../../../common/exception/fetch_exception.dart';
import '../../../component/http/http_client.dart';
import '../model/auth_data_model.dart';
import '../model/auth_exception.dart';
import '../model/network/auth_response_type.dart';

class AuthService {
  const AuthService({
    required HttpClient mobileClient,
    required HttpClient proxyClient,
  })  : _mobileClient = mobileClient,
        _proxyClient = proxyClient;

  final HttpClient _mobileClient;
  final HttpClient _proxyClient;

  login({
    required String login,
    required String password,
  }) async {
    try {
      final response = await _proxyClient.post('/getAccountAuthData', body: {
        'email': login,
        'password': password,
      });

      return response.data;
    } on DioException catch (e) {
      final dynamic data = e.response?.data;

      AuthFailureType type = AuthFailureType.unknown;

      if (data != null && data is Map) {
        if (data.containsKey('isAuthError')) {
          type = AuthFailureType.auth;
        } else if (data.containsKey('isCaptchaError')) {
          type = AuthFailureType.captcha;
        }
      }

      throw AuthException(type);
    } catch (e) {
      throw FetchException();
    }
  }

  Future<Map<String, dynamic>?> fetchMe(String connectSid) async {
    try {
      final response = await _mobileClient.get('/me');

      return response.data;
    } catch (e) {
      throw FetchException();
    }
  }

  /// Отправляем запрос на главную страницу с данными пользователя
  /// в заголовке запроса, чтобы в дальнейшем вытащить из мета тега
  /// csrf-token соответственно токен csrf
  Future<String> fetchRawMainPage(AuthDataModel data) async {
    try {
      final options = Options(headers: {'Cookie': data.toCookieString()});

      final response = await _mobileClient.get(
        'https://habr.com',
        options: options,
      );

      return response.data;
    } catch (e) {
      throw FetchException();
    }
  }
}
