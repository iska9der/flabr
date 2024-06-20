part of 'part.dart';

class SummaryClient extends DioClient {
  SummaryClient(super.client, {required SummaryTokenRepository tokenRepository})
      : _tokenRepository = tokenRepository {
    client.options = client.options.copyWith(baseUrl: 'https://300.ya.ru/api');

    client.interceptors.clear();
    client.interceptors.add(_authInterceptor());
  }

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
}
