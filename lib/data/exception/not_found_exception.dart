import 'app_exception.dart';

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Не найдено']);
}
