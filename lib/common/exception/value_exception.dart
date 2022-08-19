import 'displayable_exception.dart';

class ValueException implements DisplayableException {
  final dynamic message;

  ValueException([this.message]);

  @override
  String toString() {
    Object? message = this.message;
    if (message == null) return "Exception";
    return "$message";
  }
}
