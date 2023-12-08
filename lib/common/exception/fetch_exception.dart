import 'displayable_exception.dart';

class FetchException implements DisplayableException {
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
