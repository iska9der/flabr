import 'package:dio/dio.dart';
import 'package:flabr/core/component/http/http.dart';
import 'package:flabr/data/exception/exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'DioClient preserves transport error metadata and stack trace',
    () async {
      final requestOptions = RequestOptions(path: '/articles');
      final originalStackTrace = StackTrace.fromString('transport stack');
      final dioException = DioException(
        requestOptions: requestOptions,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 503,
          data: const <String, dynamic>{'errorCode': 'UNAVAILABLE'},
        ),
        type: DioExceptionType.badResponse,
        stackTrace: originalStackTrace,
      );
      final dio = Dio()
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (_, handler) => handler.reject(dioException),
          ),
        );
      final client = DioClient(dio);

      try {
        await client.get('/articles');
        fail('The request must throw FetchException');
      } on FetchException catch (error, stackTrace) {
        expect(error.type, FetchExceptionType.requestFailed);
        expect(error.dioType, DioExceptionType.badResponse);
        expect(error.statusCode, 503);
        expect(error.responseData, {'errorCode': 'UNAVAILABLE'});
        expect(stackTrace.toString(), contains('transport stack'));
      }
    },
  );

  test(
    'comments endpoint maps transport payload to its specific exception',
    () {
      final requestOptions = RequestOptions(path: '/articles/1/comments');
      final dioException = DioException(
        requestOptions: requestOptions,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 400,
          data: const <String, dynamic>{
            'httpCode': 409,
            'errorCode': 'POST_IN_DRAFTS',
          },
        ),
        type: DioExceptionType.badResponse,
      );
      final transportException = FetchException.fromDioException(dioException);

      final exception = CommentsListException.fromFetchException(
        transportException,
      );

      expect(exception.httpCode, 409);
      expect(exception.errorCode, 'POST_IN_DRAFTS');
    },
  );

  test('endpoint-specific FetchException keeps transport metadata', () {
    final requestOptions = RequestOptions(path: '/users/me/comments');
    final dioException = DioException(
      requestOptions: requestOptions,
      response: Response(
        requestOptions: requestOptions,
        statusCode: 429,
      ),
      type: DioExceptionType.badResponse,
    );
    final transportException = FetchException.fromDioException(dioException);

    final exception = transportException.withType(
      FetchExceptionType.userCommentsLoadFailed,
    );

    expect(exception.type, FetchExceptionType.userCommentsLoadFailed);
    expect(exception.dioType, DioExceptionType.badResponse);
    expect(exception.statusCode, 429);
  });
}
