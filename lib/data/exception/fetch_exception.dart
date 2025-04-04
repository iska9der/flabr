import 'app_exception.dart';

class FetchException extends AppException {
  const FetchException([super.message = 'Не удалось выполнить запрос']);
}
