import 'package:dio/dio.dart';

import '../../feature/auth/model/auth_data_model.dart';
import '../../feature/auth/service/token_service.dart';

class HttpClient {
  HttpClient(this.client, {this.tokenService}) {
    client.options = client.options.copyWith(
      connectTimeout: 10000,
      receiveTimeout: 10000,
    );

    if (tokenService != null) {
      client.interceptors.clear();
      client.interceptors.add(_interceptor());
    }
  }

  final Dio client;
  final TokenService? tokenService;

  Interceptor _interceptor() {
    return InterceptorsWrapper(
      onRequest: (request, handler) async {
        AuthDataModel? authData = await tokenService!.getData();

        if (authData != null) {
          request.headers['Cookie'] = 'connect_sid=${authData.connectSId}';

          return handler.next(request);
        }

        handler.next(request);
      },
    );
  }

  Future<Response> get(String url) => client.get(url);

  Future<Response> post(String url, {dynamic body}) =>
      client.post(url, data: body);

  Future<Response> put(String url, {dynamic body}) =>
      client.put(url, data: body);

  Future<Response> patch(String url, {dynamic body}) =>
      client.patch(url, data: body);

  Future<Response> delete(String url, {dynamic body}) => client.delete(url);
}
