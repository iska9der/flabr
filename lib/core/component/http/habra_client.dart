import 'dart:async';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';

import '../../../data/model/language/language.dart';
import '../../../data/repository/repository.dart';
import '../../constants/constants.dart';
import '../logger/logger.dart';
import 'client_adapter/client_adapter.dart';
import 'dio_client.dart';

class HabraClient extends DioClient {
  HabraClient(
    super.dio, {
    required this.logger,
    required this.tokenRepository,
    required this.languageRepository,
  });

  final Logger logger;
  final TokenRepository tokenRepository;
  final LanguageRepository languageRepository;

  Completer<void>? _csrfCompleter;

  Future<void> init() async {
    dio.httpClientAdapter = makeHttpClientAdapter();

    dio.interceptors.clear();
    if (!kIsWeb) {
      dio.interceptors.add(CookieManager(tokenRepository.cookieJar));
    } else {
      dio.options.extra = {...dio.options.extra, 'withCredentials': true};
    }

    dio.interceptors.add(_csrfInterceptor());
    dio.interceptors.add(_languageInterceptor());
  }

  Future<void> _fetchCsrf({
    required String cookies,
    String url = 'https://habr.com/ru/conversations/',
  }) async {
    // Уже запущен — возвращаем текущий future
    if (_csrfCompleter != null) {
      return _csrfCompleter!.future;
    }

    _csrfCompleter = Completer<void>();

    try {
      final options = Options(
        headers: {'Cookie': cookies, Keys.skipCsrf: true},
      );
      final response = await get(url, options: options);
      final String rawHtml = response.data;

      final indexOfCsrf = rawHtml.indexOf(Keys.csrfToken);
      if (indexOfCsrf == -1) {
        return;
      }

      final indexOfStart = rawHtml.indexOf(Keys.csrfToken) + 11;
      final indexOfFirstQuote = rawHtml.indexOf('"', indexOfStart) + 1;
      final indexOfLastQuote = rawHtml.indexOf('"', indexOfFirstQuote);

      final csrf = rawHtml.substring(indexOfFirstQuote, indexOfLastQuote);
      tokenRepository.setCsrf(csrf);
    } catch (e, stack) {
      logger.error('Не удалось обновить csrf', e, stack);
    } finally {
      _csrfCompleter?.complete();
      _csrfCompleter = null;
    }
  }

  Interceptor _csrfInterceptor() {
    return InterceptorsWrapper(
      onRequest: (request, handler) async {
        /// Избавляемся от циклического запроса csrf
        if (request.headers.containsKey(Keys.skipCsrf)) {
          request.headers.remove(Keys.skipCsrf);
          return handler.next(request);
        }

        /// Если нет токена - нет смысла получать csrf
        final cookieList = await tokenRepository.cookieJar.loadForRequest(
          request.uri,
        );
        final hasAuthCookie = cookieList.any(
          (cookie) => cookie.name == Keys.sidToken,
        );
        if (!hasAuthCookie) {
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
          await _fetchCsrf(cookies: cookies, url: url);
          return handler.next(request);
        }

        /// Берем csrf токен из хранилища.
        /// Если в хранилище его нет - парсим
        String? csrfToken = tokenRepository.csrf;
        if (csrfToken == null) {
          final cookies = CookieManager.getCookies(cookieList);
          await _fetchCsrf(cookies: cookies);
          csrfToken = tokenRepository.csrf;
        }

        /// Добавляем csrf токен в заголовки
        if (csrfToken != null) {
          request.headers[Keys.csrfToken] = csrfToken;
        }

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
        final langCookies = [
          Cookie('fl', pubsLangsUri)
            ..domain = domain
            ..path = path,
          Cookie('hl', uiLang)
            ..domain = domain
            ..path = path,
        ];

        final previousCookies = await tokenRepository.cookieJar.loadForRequest(
          request.uri,
        );
        final newCookies = CookieManager.getCookies([
          ...previousCookies,
          ...langCookies,
        ]);

        request.headers['cookie'] = newCookies.isNotEmpty ? newCookies : null;
        request.queryParameters.addAll({'fl': pubsLangs, 'hl': uiLang});

        handler.next(request);
      },
    );
  }
}
