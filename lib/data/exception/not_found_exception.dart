import '../../i18n/i18n.dart';
import 'app_exception.dart';

class NotFoundException extends AppException {
  const NotFoundException([super.message]);

  @override
  String get defaultMessage => t.comment.notFound;
}
