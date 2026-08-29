import 'package:dio/dio.dart';

import 'app_exception.dart';

class CommentsListException extends AppException {
  const CommentsListException([
    this.httpCode = 400,
    this.errorCode = 'BAD_REQUEST',
    super.message,
  ]);

  final int httpCode;
  final String errorCode;

  static AppException fromDioException(DioException exception) {
    var httpCode = 400;
    var errorCode = 'BAD_REQUEST';

    if (exception.response?.data case final Map<String, dynamic> data) {
      httpCode = data['httpCode'] as int? ?? httpCode;
      errorCode = data['errorCode'] as String? ?? errorCode;
    }

    return CommentsListException(httpCode, errorCode);
  }
}
