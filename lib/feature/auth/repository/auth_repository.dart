import 'package:dio/dio.dart';

import '../../../common/exception/fetch_exception.dart';
import '../../../component/http/http_client.dart';
import '../model/auth_exception.dart';
import '../model/network/auth_response_type.dart';

class AuthRepository {
  const AuthRepository({
    required HttpClient baseClient,
    required HttpClient proxyClient,
  })  : _baseClient = baseClient,
        _proxyClient = proxyClient;

  final HttpClient _baseClient;
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

  Future<Map<String, dynamic>> fetchMe(String connectSid) async {
    try {
      final response = await _baseClient.get('/me');

      return response.data;
    } catch (e) {
      throw FetchException();
    }
  }
}
