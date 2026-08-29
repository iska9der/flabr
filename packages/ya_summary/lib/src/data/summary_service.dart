import 'package:dio/dio.dart';
import '../../i18n/i18n.dart';

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
        SummaryException(yaSummaryT.summary.linkFetchError),
        e.stackTrace,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> fetchSharedData(String token) async {
    try {
      final response = await _client.post(
        '/sharing?nr=&utm_referrer=',
        body: {'token': token},
      );

      if (response.data['status_code'] != 2) {
        throw SummaryException(yaSummaryT.summary.fetchError);
      }

      return response.data;
    } on DioException catch (e) {
      Error.throwWithStackTrace(
        SummaryException(yaSummaryT.summary.fetchError),
        e.stackTrace,
      );
    }
  }
}
