import 'package:dio/dio.dart';

class HttpClient {
  HttpClient(this.client);

  final Dio client;

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
