import 'app_exception.dart';

enum FetchExceptionType {
  requestFailed,
  bookmarkCommentsLoadFailed,
  userCommentsLoadFailed,
  missingMimeType,
}

class FetchException extends AppException {
  const FetchException([
    super.message,
    this.type = .requestFailed,
  ]);

  final FetchExceptionType type;
}
