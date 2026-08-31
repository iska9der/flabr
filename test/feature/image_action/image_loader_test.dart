import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flabr/core/component/http/http.dart';
import 'package:flabr/data/exception/missing_mime_type_exception.dart';
import 'package:flabr/feature/image_action/service/image_loader.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('loads typed image data from a binary response', () async {
    final bytes = Uint8List.fromList([1, 2, 3]);
    final loader = ImageLoaderImpl(
      _StubHttpClient(
        Response(
          data: bytes,
          headers: Headers.fromMap({
            Headers.contentTypeHeader: ['image/png'],
          }),
          requestOptions: RequestOptions(path: '/image'),
        ),
      ),
    );

    final image = await loader.load(
      'https://habr.com/images/photo.png?width=100',
    );

    expect(image.name, 'photo.png');
    expect(image.mimeType, 'image/png');
    expect(image.bytes, same(bytes));
  });

  test('throws MissingMimeTypeException when the header is absent', () {
    final loader = ImageLoaderImpl(
      _StubHttpClient(
        Response(
          data: Uint8List(0),
          requestOptions: RequestOptions(path: '/image'),
        ),
      ),
    );

    expect(
      loader.load('https://habr.com/images/photo.png'),
      throwsA(isA<MissingMimeTypeException>()),
    );
  });
}

final class _StubHttpClient implements HttpClient {
  const _StubHttpClient(this.response);

  final Response response;

  @override
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParams,
    Options? options,
  }) async => response;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
