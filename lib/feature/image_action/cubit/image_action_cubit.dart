import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';

import '../../../core/component/http/http.dart';
import '../../../data/exception/exception.dart';

part 'image_action_state.dart';

class ImageActionCubit extends Cubit<ImageActionState> {
  ImageActionCubit({required HttpClient client, required String url})
    : _client = client,
      super(ImageActionState(url: url)) {
    _init();
  }

  final HttpClient _client;
  final String additionalPath = 'images';

  Future<void> _init() async {
    if (state.url.isEmpty) {
      return emit(state.copyWith(isSaveEnabled: false));
    }

    if (kIsWeb || !await FlutterFileDialog.isPickDirectorySupported()) {
      return emit(state.copyWith(isSaveEnabled: false));
    }
  }

  Future<void> _parseImage() async {
    if (state.bytes != null) return;

    final response = await _client.get(
      state.url,
      options: Options(responseType: ResponseType.bytes),
    );

    if (!response.headers.map.containsKey('content-type')) {
      throw const FetchException('В заголовках не указан mime/type');
    }

    final name = path.basename(state.url);
    final mimeType = response.headers.map['content-type']!.first;
    final bytes = Uint8List.fromList(response.data as List<int>);

    emit(state.copyWith(name: name, mimeType: mimeType, bytes: bytes));
  }

  Future<void> pickAndSave() async {
    if (state.status == ImageActionStatus.loading || !state.isSaveEnabled) {
      return;
    }

    try {
      emit(state.copyWith(status: ImageActionStatus.loading));

      final pickedDirectory = await FlutterFileDialog.pickDirectory();
      if (pickedDirectory == null) {
        return emit(state.copyWith(status: ImageActionStatus.initial));
      }

      await _parseImage();

      await FlutterFileDialog.saveFileToDirectory(
        directory: pickedDirectory,
        data: state.bytes!,
        fileName: state.name,
        mimeType: state.mimeType,
        replace: true,
      );

      emit(state.copyWith(status: ImageActionStatus.success));
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: ImageActionStatus.failure,
          error: error.parseException(),
        ),
      );

      super.onError(error, stackTrace);
    }
  }

  Future<void> share() async {
    if (state.status == ImageActionStatus.loading || !state.isShareEnabled) {
      return;
    }

    try {
      emit(state.copyWith(status: ImageActionStatus.loading));

      await _parseImage();

      await Share.shareXFiles([
        XFile.fromData(
          state.bytes!,
          name: state.name,
          mimeType: state.mimeType,
        ),
      ]);

      emit(state.copyWith(status: ImageActionStatus.success));
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: ImageActionStatus.failure,
          error: error.parseException(),
        ),
      );

      super.onError(error, stackTrace);
    }
  }
}
