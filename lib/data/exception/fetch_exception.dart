import 'package:dio/dio.dart';

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
  ]) : dioType = null,
       statusCode = null,
       responseData = null;

  const FetchException._({
    String? message,
    this.type = .requestFailed,
    this.dioType,
    this.statusCode,
    this.responseData,
  }) : super(message);

  factory FetchException.fromDioException(DioException exception) {
    return FetchException._(
      dioType: exception.type,
      statusCode: exception.response?.statusCode,
      responseData: exception.response?.data,
    );
  }

  final FetchExceptionType type;
  final DioExceptionType? dioType;
  final int? statusCode;
  final Object? responseData;

  FetchException withType(FetchExceptionType type) {
    return FetchException._(
      message: message,
      type: type,
      dioType: dioType,
      statusCode: statusCode,
      responseData: responseData,
    );
  }
}
