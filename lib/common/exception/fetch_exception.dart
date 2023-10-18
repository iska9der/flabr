import 'displayable_exception.dart';

class FetchException implements DisplayableException {
  final dynamic message;

  FetchException([this.message]);

  @override
  String toString() {
    String result = 'Не удалось получить данные';
    Object? message = this.message;
    if (message == null) return result;
    return '$result: $message';
  }
}
