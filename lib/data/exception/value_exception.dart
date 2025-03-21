import 'app_exception.dart';

class ValueException implements AppException {
  final dynamic message;

  ValueException([this.message]);

  @override
  String toString() {
    String result = 'Ошибка значения';
    Object? message = this.message;
    if (message == null) return result;
    return '$result: $message';
  }
}
