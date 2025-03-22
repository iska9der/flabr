import 'app_exception.dart';

class FetchException implements AppException {
  FetchException([this.message]);

  final String? message;

  @override
  String toString() {
    String result = 'Не удалось получить данные';

    var message = this.message;
    if (message == null) return result;
    return message;
  }
}
