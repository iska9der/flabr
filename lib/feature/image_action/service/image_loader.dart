import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;

import '../../../core/component/http/http.dart';
import '../../../data/exception/missing_mime_type_exception.dart';
import '../model/image_data.dart';

abstract interface class ImageLoader {
  Future<ImageData> load(String url);
}

@LazySingleton(as: ImageLoader)
class ImageLoaderImpl implements ImageLoader {
  const ImageLoaderImpl(
    @Named('siteClient') this._client,
  );

  final HttpClient _client;

  @override
  Future<ImageData> load(String url) async {
    final response = await _client.get(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    final mimeType = response.headers.value(Headers.contentTypeHeader);

    if (mimeType == null) {
      throw const MissingMimeTypeException();
    }

    final data = response.data as List<int>;

    return ImageData(
      name: path.basename(Uri.parse(url).path),
      mimeType: mimeType,
      bytes: data is Uint8List ? data : Uint8List.fromList(data),
    );
  }
}
