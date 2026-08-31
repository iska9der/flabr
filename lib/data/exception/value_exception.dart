import 'app_exception.dart';

enum ValueExceptionType {
  invalidValue,
  unknownHub,
  unknownFeedPublication,
  unknownPublicationFlow,
  unknownSort,
  unknownLanguage,
  searchNotImplemented,
  wrongPublicationDestination,
  publicationOperationFailed,
}

class ValueException extends AppException {
  const ValueException([this.type = .invalidValue]);

  final ValueExceptionType type;
}
