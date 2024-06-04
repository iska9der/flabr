import 'package:dio/dio.dart';

import 'part.dart';

class CommentsListException implements DisplayableException {
  int httpCode;
  String errorCode;
  String message;

  CommentsListException([
    this.httpCode = 400,
    this.errorCode = 'BAD_REQUEST',
    this.message = 'Не удалось получить данные',
  ]);

  static fromDioException(DioException exception) {
    int httpCode = 400;
    String errorCode = 'BAD_REQUEST';
    String message = 'Не удалось получить данные';

    if (exception.response?.data != null) {
      Map<String, dynamic> data = exception.response!.data;
      httpCode = data['httpCode'];
      if (data.containsKey('errorCode')) {
        message = parseMessage(data['errorCode']);
      }
    }

    return CommentsListException(httpCode, errorCode, message);
  }

  static parseMessage(String errorCode) {
    return switch (errorCode) {
      'NOT_FOUND' => 'Не найдено',
      'POST_IN_DRAFTS' => 'Публикация в черновиках',
      'POST_COMMENTS_DISABLED' => 'Комментарии к этой публикации отключены',
      _ => 'Не удалось получить данные',
    };
  }

  @override
  String toString() {
    return message;
  }
}
