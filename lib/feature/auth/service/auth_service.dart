import 'package:dio/dio.dart';

import '../../../common/exception/fetch_exception.dart';
import '../../../component/http/http_client.dart';
import '../model/auth_data_model.dart';

class AuthService {
  const AuthService({
    required HttpClient mobileClient,
  }) : _mobileClient = mobileClient;

  final HttpClient _mobileClient;

  Future<Map<String, dynamic>?> fetchMe() async {
    try {
      final response = await _mobileClient.get('/me');

      return response.data;
    } catch (e) {
      throw FetchException();
    }
  }

  /// Отправляем запрос на страницу с данными пользователя в заголовке запроса,
  /// чтобы в дальнейшем вытащить из мета тега csrf-token
  Future<String> fetchRawMainPage(AuthDataModel data) async {
    try {
      final options = Options(headers: {'Cookie': data.toCookieString()});
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
