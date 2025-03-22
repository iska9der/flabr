import 'package:dio/dio.dart';

import 'summary_repository.dart';

class SummaryClient {
  SummaryClient(
    this.dio, {
    required SummaryTokenRepository tokenRepository,
  }) : _tokenRepository = tokenRepository {
    dio.options = dio.options.copyWith(baseUrl: 'https://300.ya.ru/api');

    dio.interceptors.clear();
    dio.interceptors.add(_authInterceptor());
  }

  final Dio dio;
  final SummaryTokenRepository _tokenRepository;

  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (request, handler) async {
        String? token = await _tokenRepository.getToken();

        if (token != null) {
          request.headers['Authorization'] = 'OAuth $token';
          return handler.next(request);
        }

        handler.next(request);
      },
    );
  }

  Future<Response> post(
    String url, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Options? options,
  }) =>
      dio.post(
        url,
        data: body,
        queryParameters: queryParams,
        options: options,
      );
}
