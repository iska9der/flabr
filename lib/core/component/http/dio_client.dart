import 'package:dio/dio.dart';

import 'http_client.dart';

class DioClient implements HttpClient {
  DioClient(this.dio);

  final Dio dio;

  @override
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParams,
    Options? options,
  }) => dio.get(url, queryParameters: queryParams, options: options);

  @override
  Future<Response> post(
    String url, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Options? options,
  }) =>
      dio.post(url, data: body, queryParameters: queryParams, options: options);

  @override
  Future<Response> put(
    String url, {
    dynamic body,
    Map<String, dynamic>? queryParams,
  }) => dio.put(url, data: body, queryParameters: queryParams);

  @override
  Future<Response> patch(
    String url, {
    dynamic body,
    Map<String, dynamic>? queryParams,
  }) => dio.patch(url, data: body, queryParameters: queryParams);

  @override
  Future<Response> delete(String url, {dynamic body}) =>
      dio.delete(url, data: body);
}
