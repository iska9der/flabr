import 'app_exception.dart';

class DatabaseException extends AppException {
  const DatabaseException(this.cause);

  final Object cause;

  factory DatabaseException.from(Object error) => DatabaseException(error);
}
