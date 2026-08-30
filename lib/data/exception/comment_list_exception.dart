import 'app_exception.dart';
import 'fetch_exception.dart';

class CommentsListException extends AppException {
  const CommentsListException([
    this.httpCode = 400,
    this.errorCode = 'BAD_REQUEST',
    super.message,
  ]);

  final int httpCode;
  final String errorCode;

  static CommentsListException fromFetchException(FetchException exception) {
    var httpCode = exception.statusCode ?? 400;
    var errorCode = 'BAD_REQUEST';

    if (exception.responseData case final Map<String, dynamic> data) {
      httpCode = data['httpCode'] as int? ?? httpCode;
      errorCode = data['errorCode'] as String? ?? errorCode;
    }

    return CommentsListException(httpCode, errorCode);
  }
}
