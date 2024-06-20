part of 'part.dart';

class HabraClient extends DioClient {
  HabraClient(super.client, {required this.tokenRepository}) {
    client.options = client.options.copyWith(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    );

    client.interceptors.clear();
    client.interceptors.add(_authInterceptor());
  }

  final TokenRepository tokenRepository;

  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (request, handler) async {
        Tokens? tokens = await tokenRepository.getTokens();
        String? csrfToken = await tokenRepository.getCsrf();

        if (tokens != null && !request.headers.containsKey('Cookie')) {
          request.headers['Cookie'] = 'connect_sid=${tokens.connectSID};';
          request.headers['csrf-token'] = csrfToken;
          return handler.next(request);
        }

        handler.next(request);
      },
    );
  }
}
