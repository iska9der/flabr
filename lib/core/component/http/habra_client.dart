part of 'part.dart';

class HabraClient extends DioClient {
  HabraClient(super.client, {required this.tokenRepository}) {
    client.options = client.options.copyWith(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    );

    client.interceptors.clear();
    client.interceptors.add(_interceptor());
  }

  final TokenRepository tokenRepository;

  Interceptor _interceptor() {
    return InterceptorsWrapper(
      onRequest: (request, handler) async {
        AuthDataModel? authData = await tokenRepository.getData();
        String? csrfToken = await tokenRepository.getCsrf();

        if (authData != null && !request.headers.containsKey('Cookie')) {
          request.headers['Cookie'] = 'connect_sid=${authData.connectSID};';
          request.headers['csrf-token'] = csrfToken;
          return handler.next(request);
        }

        handler.next(request);
      },
    );
  }
}
