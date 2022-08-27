import 'displayable_exception.dart';

class FetchException implements DisplayableException {
  final dynamic message;

  FetchException([this.message]);

  @override
  String toString() {
    Object? message = this.message;
    if (message == null) return 'Не удалось получить данные';
    return '$message';
  }
}
