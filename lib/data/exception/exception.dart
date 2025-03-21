import 'app_exception.dart';

export 'app_exception.dart';
export 'comment_list_exception.dart';
export 'fetch_exception.dart';
export 'not_found_exception.dart';
export 'value_exception.dart';

extension ExceptionExtension on Object {
  String parseException([
    String fallback = 'Не удалось выполнить',
    StackTrace? trace,
  ]) {
    if (this is AppException) {
      return toString();
    }

    return fallback;
  }
}
