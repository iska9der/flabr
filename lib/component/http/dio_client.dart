part of 'http_part.dart';

class DioClient implements HttpClient {
  DioClient(this.client);

  final Dio client;

  @override
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

  @override
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

  @override
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

  @override
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

  @override
  Future<Response> delete(String url, {dynamic body}) => client.delete(url);
}
