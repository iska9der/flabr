import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path/path.dart' as path;

import '../../../../common/exception/fetch_exception.dart';
import '../../../../component/http/http_client.dart';

part 'image_download_state.dart';

class ImageDownloadCubit extends Cubit<ImageDownloadState> {
  ImageDownloadCubit({
    required HttpClient client,
    required String url,
  })  : _client = client,
        super(ImageDownloadState(url: url)) {
    _init();
  }

  final HttpClient _client;
  final String additionalPath = 'images';

  _init() async {
    if (state.url.isEmpty) {
      return emit(state.copyWith(status: ImageDownloadStatus.notSupported));
    }

    if (!await FlutterFileDialog.isPickDirectorySupported()) {
      return emit(state.copyWith(status: ImageDownloadStatus.notSupported));
    }
  }

  pickAndSave() async {
    if (state.status == ImageDownloadStatus.loading ||
        state.status == ImageDownloadStatus.notSupported) return;

    try {
      emit(state.copyWith(status: ImageDownloadStatus.loading));

      final pickedDirectory = await FlutterFileDialog.pickDirectory();
      if (pickedDirectory == null) {
        return emit(state.copyWith(status: ImageDownloadStatus.initial));
      }

      final response = await _client.get(
        state.url,
        options: Options(responseType: ResponseType.bytes),
      );

      if (!response.headers.map.containsKey('content-type')) {
        throw FetchException('В заголовках не указан mime/type');
      }

      final basename = path.basename(state.url);
      final mimeType = response.headers.map['content-type']!.first;
      final data = Uint8List.fromList(response.data as List<int>);

      await FlutterFileDialog.saveFileToDirectory(
        directory: pickedDirectory,
        data: data,
        fileName: basename,
        mimeType: mimeType,
        replace: true,
      );

      emit(state.copyWith(status: ImageDownloadStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: ImageDownloadStatus.failure,
        error: e.toString(),
      ));

      rethrow;
    }
  }
}
