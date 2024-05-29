import 'package:dio/dio.dart';

class HttpClient {
  HttpClient(this.client);

  final Dio client;

  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParams,
    Options? options,
  }) =>
      client.get(
        url,
        queryParameters: queryParams,
        options: options,
      );

  Future<Response> post(
    String url, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Options? options,
  }) =>
      client.post(
        url,
        data: body,
        queryParameters: queryParams,
        options: options,
      );

  Future<Response> put(
    String url, {
    dynamic body,
    Map<String, dynamic>? queryParams,
  }) =>
      client.put(
        url,
        data: body,
        queryParameters: queryParams,
      );

  Future<Response> patch(
    String url, {
    dynamic body,
    Map<String, dynamic>? queryParams,
  }) =>
      client.patch(
        url,
        data: body,
        queryParameters: queryParams,
      );

  Future<Response> delete(String url, {dynamic body}) => client.delete(url);
}
