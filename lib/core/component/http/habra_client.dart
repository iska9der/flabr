import 'package:dio/dio.dart';

import '../../../data/model/tokens_model.dart';
import '../../../data/repository/repository.dart';
import '../../constants/constants.dart';
import 'client_adapter/client_adapter.dart';
import 'dio_client.dart';

class HabraClient extends DioClient {
  HabraClient(super.dio, {required this.tokenRepository}) {
    dio.httpClientAdapter = makeHttpClientAdapter();
    dio.interceptors.clear();
    dio.interceptors.add(_authInterceptor());
  }

  final TokenRepository tokenRepository;
  String? csrfToken;

  Future<String?> _fetchCsrf({
    required String cookies,
    String url = 'https://habr.com/ru/conversations/',
  }) async {
    try {
      final options = Options(headers: {'Cookie': cookies});
      final response = await get(url, options: options);

      String rawHtml = await response.data;

      int indexOfCsrf = rawHtml.indexOf('csrf-token');
      if (indexOfCsrf == -1) {
        return null;
      }

      String csrf = '';
      int indexOfCsrfStart = rawHtml.indexOf('csrf-token') + 11;
      int indexOfFirstQuote = rawHtml.indexOf('"', indexOfCsrfStart) + 1;
      int indexOfLastQuote = rawHtml.indexOf('"', indexOfFirstQuote);
      csrf = rawHtml.substring(indexOfFirstQuote, indexOfLastQuote);
      tokenRepository.setCsrf(csrf);

      return csrf;
    } catch (e) {
      return null;
    }
  }

  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (request, handler) async {
        Tokens? tokens = await tokenRepository.getTokens();

        if (tokens != null && !request.headers.containsKey('Cookie')) {
          final cookies = tokens.toCookieString();
          request.headers['Cookie'] = cookies;

          /// механизм обновления csrf токена в зависимости от указанного заголовка:
          /// если в заголовках указан ключ Keys.renewCsrf, берем по нему url
          /// страницы из которой нужно вытащить csrf токен
          if (request.headers.containsKey(Keys.renewCsrf)) {
            final url = request.headers[Keys.renewCsrf];
            request.headers.remove(Keys.renewCsrf);

            csrfToken = await _fetchCsrf(cookies: cookies, url: url);
          } else {
            csrfToken ??=
                await tokenRepository.getCsrf() ??
                await _fetchCsrf(cookies: cookies);
          }

          if (csrfToken != null) {
            request.headers['csrf-token'] = csrfToken;
          }
        }

        handler.next(request);
      },
    );
  }
}
