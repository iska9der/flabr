import 'package:dio/dio.dart';

import 'app_exception.dart';

enum FetchExceptionType {
  requestFailed,
  bookmarkCommentsLoadFailed,
  userCommentsLoadFailed,
}

class FetchException extends AppException {
  const FetchException([this.type = .requestFailed])
    : dioType = null,
      statusCode = null,
      responseData = null;

  const FetchException._({
    this.type = .requestFailed,
    this.dioType,
    this.statusCode,
    this.responseData,
  });

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
      type: type,
      dioType: dioType,
      statusCode: statusCode,
      responseData: responseData,
    );
  }
}
