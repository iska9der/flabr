import 'package:dio/dio.dart';

import '../../feature/auth/model/auth_data_model.dart';
import '../../feature/auth/repository/token_repository.dart';

class HttpClient {
  HttpClient(this.client, {this.tokenRepository}) {
    client.options = client.options.copyWith(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    );

    if (tokenRepository != null) {
      client.interceptors.clear();
      client.interceptors.add(_interceptor());
    }
  }

  final Dio client;
  final TokenRepository? tokenRepository;

  Interceptor _interceptor() {
    return InterceptorsWrapper(
      onRequest: (request, handler) async {
        AuthDataModel? authData = await tokenRepository!.getData();
        String? csrfToken = await tokenRepository!.getCsrf();

        if (authData != null && !request.headers.containsKey('Cookie')) {
          request.headers['Cookie'] = 'connect_sid=${authData.connectSID};';
          request.headers['csrf-token'] = csrfToken;
          return handler.next(request);
        }

        handler.next(request);
      },
    );
  }

  Future<Response> get(String url, {Options? options}) => client.get(
        url,
        options: options,
      );

  Future<Response> post(String url, {dynamic body, Options? options}) =>
      client.post(
        url,
        data: body,
        options: options,
      );

  Future<Response> put(String url, {dynamic body}) =>
      client.put(url, data: body);

  Future<Response> patch(String url, {dynamic body}) =>
      client.patch(url, data: body);

  Future<Response> delete(String url, {dynamic body}) => client.delete(url);
}
