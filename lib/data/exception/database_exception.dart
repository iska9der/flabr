import 'app_exception.dart';

class DatabaseException extends AppException {
  const DatabaseException([super.message = 'Ошибка базы данных']);
}
