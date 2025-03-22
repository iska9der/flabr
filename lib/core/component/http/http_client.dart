import 'package:dio/dio.dart';

abstract interface class HttpClient {
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParams,
    Options? options,
  });

  Future<Response> post(
    String url, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Options? options,
  });

  Future<Response> put(
    String url, {
    dynamic body,
    Map<String, dynamic>? queryParams,
  });

  Future<Response> patch(
    String url, {
    dynamic body,
    Map<String, dynamic>? queryParams,
  });

  Future<Response> delete(String url, {dynamic body});
}
