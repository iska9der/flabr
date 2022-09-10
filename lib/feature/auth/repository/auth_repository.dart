import 'package:dio/dio.dart';

import '../../../common/exception/fetch_exception.dart';
import '../../../component/http/http_client.dart';
import '../model/auth_exception.dart';
import '../model/network/auth_response_type.dart';

class AuthRepository {
  const AuthRepository(
    HttpClient client,
  ) : _client = client;

  final HttpClient _client;

  login({
    required String login,
    required String password,
  }) async {
    try {
      final response = await _client.post('/getAccountAuthData', body: {
        'email': login,
        'password': password,
      });

      return response.data;
    } on DioError catch (e) {
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
}
