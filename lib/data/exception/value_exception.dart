part of 'part.dart';

class ValueException implements DisplayableException {
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
