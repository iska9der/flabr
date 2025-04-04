import 'package:dio/dio.dart';

import 'app_exception.dart';

class CommentsListException extends AppException {
  const CommentsListException([
    this.httpCode = 400,
    this.errorCode = 'BAD_REQUEST',
    super.message = 'Не удалось получить список комментариев',
  ]);

  final int httpCode;
  final String errorCode;

  static AppException fromDioException(DioException exception) {
    int httpCode = 400;
    String errorCode = 'BAD_REQUEST';
    String message = 'Не удалось получить список комментариев';

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
      'NOT_FOUND' => 'Не найдено',
      'POST_IN_DRAFTS' => 'Публикация в черновиках',
      'POST_COMMENTS_DISABLED' => 'Комментарии к этой публикации отключены',
      _ => 'Не удалось получить список комментариев',
    };
  }
}
