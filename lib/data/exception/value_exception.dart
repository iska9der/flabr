import 'app_exception.dart';

enum ValueExceptionType {
  invalidValue,
  unknownHub,
  unknownFeedPublication,
  unknownSort,
  unknownLanguage,
  searchNotImplemented,
  wrongPublicationDestination,
  publicationOperationFailed,
}

class ValueException extends AppException {
  const ValueException([
    super.message,
    this.type = .invalidValue,
  ]);

  final ValueExceptionType type;
}
