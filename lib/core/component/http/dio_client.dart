import 'package:dio/dio.dart';

import '../../../data/exception/exception.dart';
import 'http_client.dart';

class DioClient implements HttpClient {
  DioClient(this.dio);

  final Dio dio;

  @override
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParams,
    Options? options,
  }) => _execute(
    () => dio.get(url, queryParameters: queryParams, options: options),
  );

  @override
  Future<Response> post(
    String url, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Options? options,
  }) => _execute(
    () => dio.post(
      url,
      data: body,
      queryParameters: queryParams,
      options: options,
    ),
  );

  @override
  Future<Response> put(
    String url, {
    dynamic body,
    Map<String, dynamic>? queryParams,
  }) => _execute(
    () => dio.put(url, data: body, queryParameters: queryParams),
  );

  @override
  Future<Response> patch(
    String url, {
    dynamic body,
    Map<String, dynamic>? queryParams,
  }) => _execute(
    () => dio.patch(url, data: body, queryParameters: queryParams),
  );

  @override
  Future<Response> delete(String url, {dynamic body}) =>
      _execute(() => dio.delete(url, data: body));

  Future<Response> _execute(Future<Response> Function() request) async {
    try {
      return await request();
    } on DioException catch (error) {
      Error.throwWithStackTrace(
        FetchException.fromDioException(error),
        error.stackTrace,
      );
    }
  }
}
