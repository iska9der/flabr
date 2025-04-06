import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';

import '../../../data/model/language/language.dart';
import '../../../data/model/tokens_model.dart';
import '../../../data/repository/repository.dart';
import '../../constants/constants.dart';
import 'client_adapter/client_adapter.dart';
import 'dio_client.dart';

class HabraClient extends DioClient {
  HabraClient(
    super.dio, {
    required this.tokenRepository,
    required this.languageRepository,
  }) {
    dio.httpClientAdapter = makeHttpClientAdapter();
    cookieJar = CookieJar();

    dio.interceptors.clear();
    if (!kIsWeb) {
      dio.interceptors.add(CookieManager(cookieJar));
    }
    dio.interceptors.add(_authInterceptor());
    dio.interceptors.add(_csrfInterceptor());
    dio.interceptors.add(_languageInterceptor());
  }

  final TokenRepository tokenRepository;
  final LanguageRepository languageRepository;
  late final CookieJar cookieJar;
  bool csrfHandling = false;

  void _fetchCsrf({
    required String cookies,
    String url = 'https://habr.com/ru/conversations/',
  }) {
    if (csrfHandling) {
      return;
    }

    csrfHandling = true;
    final options = Options(headers: {'Cookie': cookies});

    get(url, options: options).then((response) {
      String rawHtml = response.data;

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
      csrfHandling = false;
    });
  }

  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (request, handler) async {
        Tokens? tokens = tokenRepository.tokens;

        /// Если токенов нет - добавляем их в куки.
        /// Сработает только на первых запросах,
        /// дальше [CookieManager] сам будет подставлять куки
        final headerCookies = (request.headers['Cookie'] ?? '') as String;
        if (tokens.isNotEmpty && headerCookies.isEmpty) {
          final cookies = tokens.toCookieString();
          request.headers['cookie'] = cookies;
        }

        /// Если токенов в репозитории нет - значит пользователь вышел
        /// и нужно удалить все куки
        if (tokens.isEmpty && headerCookies.isNotEmpty) {
          cookieJar.deleteAll();
          request.headers.remove('cookie');
        }

        handler.next(request);
      },
    );
  }

  Interceptor _csrfInterceptor() {
    return InterceptorsWrapper(
      onRequest: (request, handler) async {
        final headerCookies = (request.headers['Cookie'] ?? '') as String;
        final cookieList =
            headerCookies
                .split(';')
                .where((e) => e.isNotEmpty)
                .map((c) => Cookie.fromSetCookieValue(c))
                .toList();
        final isTokenExist = cookieList.any(
          (cookie) => cookie.name == 'connect_sid',
        );

        /// Если нет токена - нет смысла парсить csrf
        if (!isTokenExist) {
          return handler.next(request);
        }

        final isRenewal = request.headers.containsKey(Keys.renewCsrf);

        /// Механизм обновления csrf токена в зависимости от указанного заголовка:
        /// если в заголовках указан ключ Keys.renewCsrf, берем по нему url
        /// страницы из которой нужно вытащить csrf токен
        if (isRenewal) {
          final url = request.headers[Keys.renewCsrf];
          request.headers.remove(Keys.renewCsrf);

          final cookies = CookieManager.getCookies(cookieList);
          _fetchCsrf(cookies: cookies, url: url);
          return handler.next(request);
        }

        /// Берем csrf токен из хранилища.
        /// Если в хранилище его нет - парсим
        String? csrfToken = tokenRepository.csrf;
        if (csrfToken == null) {
          final cookies = CookieManager.getCookies(cookieList);
          _fetchCsrf(cookies: cookies);
          return handler.next(request);
        }

        /// Добавляем csrf токен в заголовки
        request.headers['csrf-token'] = csrfToken;

        handler.next(request);
      },
    );
  }

  /// issue: в авторизованном состоянии не работает смена языков
  Interceptor _languageInterceptor() {
    return InterceptorsWrapper(
      onRequest: (request, handler) async {
        final pubsLangs = LanguageEncoder.encodeLangs(
          languageRepository.lastPublications,
        );
        final pubsLangsUri = Uri.encodeComponent(pubsLangs);
        final uiLang = languageRepository.lastUI.name;
        final domain = request.uri.host;
        final path = '/';
        final cookies = [
          Cookie('fl', pubsLangsUri)
            ..domain = domain
            ..path = path,
          Cookie('hl', uiLang)
            ..domain = domain
            ..path = path,
        ];

        final previousCookies = request.headers['cookie'] as String?;

        final newCookies = CookieManager.getCookies([
          ...?previousCookies
              ?.split(';')
              .where((e) => e.isNotEmpty)
              .map((c) => Cookie.fromSetCookieValue(c)),
          ...cookies,
        ]);

        request.headers['cookie'] = newCookies.isNotEmpty ? newCookies : null;
        request.queryParameters.addAll({'fl': pubsLangs, 'hl': uiLang});

        handler.next(request);
      },
    );
  }
}
