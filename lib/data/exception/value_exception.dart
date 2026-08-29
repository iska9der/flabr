import '../../i18n/i18n.dart';
import 'app_exception.dart';

class ValueException extends AppException {
  const ValueException([super.message]);

  @override
  String get defaultMessage => t.error.valueError;
}
