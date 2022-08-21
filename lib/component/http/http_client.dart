import 'package:dio/dio.dart';

class HttpClient {
  HttpClient(this.client) {
    client.options = client.options.copyWith(
      connectTimeout: 10000,
      receiveTimeout: 10000,
    );
  }

  final Dio client;

  Future<Response> get(String url) => client.get(url);

  Future<Response> post(String url, {dynamic body}) =>
      client.post(url, data: body);

  Future<Response> put(String url, {dynamic body}) =>
      client.put(url, data: body);

  Future<Response> patch(String url, {dynamic body}) =>
      client.patch(url, data: body);

  Future<Response> delete(String url, {dynamic body}) => client.delete(url);
}
