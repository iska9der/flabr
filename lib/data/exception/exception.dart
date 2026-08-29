import '../../i18n/i18n.dart';
import 'app_exception.dart';

export 'app_exception.dart';
export 'comment_list_exception.dart';
export 'fetch_exception.dart';
export 'not_found_exception.dart';
export 'value_exception.dart';

extension ExceptionExtension on Object {
  String parseException([
    String? fallback,
    StackTrace? trace,
  ]) {
    if (this is AppException) {
      return toString();
    }

    return fallback ?? t.error.operationFailed;
  }
}
