import 'package:dio/dio.dart';

import 'summary_client.dart';
import 'summary_exception.dart';

abstract class SummaryService {
  Future<String> fetchSharingUrl(String articleUrl);

  Future<Map<String, dynamic>> fetchSharedData(String token);
}

class SummaryServiceImpl implements SummaryService {
  const SummaryServiceImpl(this._client);

  final SummaryClient _client;

  @override
  Future<String> fetchSharingUrl(String articleUrl) async {
    try {
      final response = await _client.post(
        '/sharing-url',
        body: {'article_url': articleUrl},
      );

      return response.data['sharing_url'];
    } on DioException catch (e) {
      Error.throwWithStackTrace(
        SummaryException('Не удалось получить ссылку на пересказ'),
        e.stackTrace,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> fetchSharedData(String token) async {
    try {
      final response = await _client.post(
        '/sharing',
        body: {'token': token},
      );

      if (response.data['status_code'] != 2) {
        throw SummaryException('Не удалось получить пересказ');
      }

      return response.data;
    } on DioException catch (e) {
      Error.throwWithStackTrace(
        SummaryException('Не удалось получить пересказ'),
        e.stackTrace,
      );
    }
  }
}
