import '../../i18n/i18n.dart';
import 'app_exception.dart';

class FetchException extends AppException {
  const FetchException([super.message]);

  @override
  String get defaultMessage => t.error.requestFailed;
}
