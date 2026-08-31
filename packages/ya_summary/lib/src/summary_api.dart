import 'package:dio/dio.dart';

import 'summary_exception.dart';
import 'summary_model.dart';

typedef SummaryTokenProvider = Future<String?> Function();

class SummaryApi {
  SummaryApi({
    required Dio dio,
    required SummaryTokenProvider tokenProvider,
  }) : _dio = dio,
       _tokenProvider = tokenProvider {
    _dio.options = _dio.options.copyWith(baseUrl: 'https://300.ya.ru/api');
  }

  final Dio _dio;
  final SummaryTokenProvider _tokenProvider;

  Future<SummaryModel> fetchSummary(String articleUrl) async {
    final token = await _tokenProvider();
    if (token == null || token.isEmpty) {
      throw const SummaryException(.tokenMissing);
    }

    final sharingUrl = await _fetchSharingUrl(articleUrl, token);
    final sharingToken = Uri.parse(sharingUrl).pathSegments.last;
    final data = await _fetchSharedData(sharingToken, token);

    return SummaryModel.fromMap(data);
  }

  Future<String> _fetchSharingUrl(String articleUrl, String token) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/sharing-url',
        data: {'article_url': articleUrl},
        options: _authorizedOptions(token),
      );

      return response.data!['sharing_url'] as String;
    } on DioException catch (error) {
      _throwRequestException(error, .sharingUrlFetchFailed);
    }
  }

  Future<Map<String, dynamic>> _fetchSharedData(
    String sharingToken,
    String token,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/sharing?nr=&utm_referrer=',
        data: {'token': sharingToken},
        options: _authorizedOptions(token),
      );
      final data = response.data!;

      if (data['status_code'] != 2) {
        throw const SummaryException(.summaryFetchFailed);
      }

      return data;
    } on DioException catch (error) {
      _throwRequestException(error, .summaryFetchFailed);
    }
  }

  Options _authorizedOptions(String token) {
    return Options(headers: {'Authorization': 'OAuth $token'});
  }

  Never _throwRequestException(
    DioException error,
    SummaryExceptionType fallbackType,
  ) {
    final statusCode = error.response?.statusCode;
    final type = statusCode == 401 || statusCode == 403
        ? SummaryExceptionType.unauthorized
        : fallbackType;

    Error.throwWithStackTrace(SummaryException(type), error.stackTrace);
  }
}
