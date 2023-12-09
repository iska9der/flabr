import 'package:dio/dio.dart';

import '../../../common/exception/fetch_exception.dart';
import '../../../component/http/http_client.dart';

class SummaryService {
  const SummaryService({required HttpClient client}) : _client = client;

  final HttpClient _client;

  Future<String> fetchSharingUrl(String articleUrl) async {
    try {
      final response = await _client.post(
        '/sharing-url',
        body: {'article_url': articleUrl},
      );

      return response.data['sharing_url'];
    } on DioException catch (e) {
      Error.throwWithStackTrace(
        FetchException('Не удалось получить ссылку на пересказ'),
        e.stackTrace,
      );
    }
  }

  Future<Map<String, dynamic>> fetchSharedData(String token) async {
    try {
      final response = await _client.post(
        '/sharing',
        body: {'token': token},
      );

      if (response.data['status_code'] != 2) {
        throw FetchException('Не удалось получить пересказ');
      }

      return response.data;
    } on DioException catch (e) {
      Error.throwWithStackTrace(
        FetchException('Не удалось получить пересказ'),
        e.stackTrace,
      );
    }
  }
}
