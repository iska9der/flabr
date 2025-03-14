part of 'http.dart';

class HabraClient extends DioClient {
  HabraClient(super.dio, {required this.tokenRepository}) {
    dio.options = dio.options.copyWith(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    );

    dio.interceptors.clear();
    dio.interceptors.add(_authInterceptor());
  }

  final TokenRepository tokenRepository;

  Future<String> _fetchCsrf({
    required String cookie,
    String url = 'https://habr.com/ru/conversations',
  }) async {
    final options = Options(headers: {'Cookie': cookie});
    final response = await get(url, options: options);

    String rawHtml = await response.data;

    String csrf = '';
    int indexOfCsrfStart = rawHtml.indexOf('csrf-token') + 11;
    int indexOfFirstQuote = rawHtml.indexOf('"', indexOfCsrfStart) + 1;
    int indexOfLastQuote = rawHtml.indexOf('"', indexOfFirstQuote);
    csrf = rawHtml.substring(indexOfFirstQuote, indexOfLastQuote);
    tokenRepository.setCsrf(csrf);

    return csrf;
  }

  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (request, handler) async {
        Tokens? tokens = await tokenRepository.getTokens();

        if (tokens != null && !request.headers.containsKey('Cookie')) {
          request.headers['Cookie'] = 'connect_sid=${tokens.connectSID};';

          String? csrfToken;

          /// механизм обновления csrf токена в зависимости от указанного заголовка:
          /// если в заголовках указан ключ Keys.renewCsrf, берем по нему url
          /// страницы из которой нужно вытащить csrf токен
          if (request.headers.containsKey(Keys.renewCsrf)) {
            csrfToken = await _fetchCsrf(
              cookie: tokens.toCookieString(),
              url: request.headers[Keys.renewCsrf],
            );
            request.headers.remove(Keys.renewCsrf);
          } else {
            csrfToken = await tokenRepository.getCsrf() ??
                await _fetchCsrf(cookie: tokens.toCookieString());
          }

          request.headers['csrf-token'] = csrfToken;
          return handler.next(request);
        }

        handler.next(request);
      },
    );
  }
}
