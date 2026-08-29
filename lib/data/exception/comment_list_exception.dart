import 'package:dio/dio.dart';

import '../../i18n/i18n.dart';
import 'app_exception.dart';

class CommentsListException extends AppException {
  const CommentsListException([
    this.httpCode = 400,
    this.errorCode = 'BAD_REQUEST',
    super.message,
  ]);

  final int httpCode;
  final String errorCode;
  @override
  String get defaultMessage => t.comment.fetchFailed;

  static AppException fromDioException(DioException exception) {
    int httpCode = 400;
    String errorCode = 'BAD_REQUEST';
    String message = t.comment.fetchFailed;

    if (exception.response?.data != null) {
      Map<String, dynamic> data = exception.response!.data;
      httpCode = data['httpCode'];
      if (data.containsKey('errorCode')) {
        message = parseMessage(data['errorCode']);
      }
    }

    return CommentsListException(httpCode, errorCode, message);
  }

  static String parseMessage(String errorCode) {
    return switch (errorCode) {
      'NOT_FOUND' => t.comment.notFound,
      'POST_IN_DRAFTS' => t.comment.publicationInDrafts,
      'POST_COMMENTS_DISABLED' => t.comment.disabled,
      _ => t.comment.fetchFailed,
    };
  }
}
