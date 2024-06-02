import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';

import '../../../../common/exception/fetch_exception.dart';
import '../../../../component/http/http_part.dart';

part 'image_action_state.dart';

class ImageActionCubit extends Cubit<ImageActionState> {
  ImageActionCubit({
    required HttpClient client,
    required String url,
  })  : _client = client,
        super(ImageActionState(url: url)) {
    _init();
  }

  final HttpClient _client;
  final String additionalPath = 'images';

  _init() async {
    if (state.url.isEmpty) {
      return emit(state.copyWith(isSaveEnabled: false));
    }

    if (!await FlutterFileDialog.isPickDirectorySupported()) {
      return emit(state.copyWith(isSaveEnabled: false));
    }
  }

  _parseImage() async {
    if (state.bytes != null) return;

    final response = await _client.get(
      state.url,
      options: Options(responseType: ResponseType.bytes),
    );

    if (!response.headers.map.containsKey('content-type')) {
      throw FetchException('В заголовках не указан mime/type');
    }

    final name = path.basename(state.url);
    final mimeType = response.headers.map['content-type']!.first;
    final bytes = Uint8List.fromList(response.data as List<int>);

    emit(state.copyWith(name: name, mimeType: mimeType, bytes: bytes));
  }

  pickAndSave() async {
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
    } catch (e) {
      emit(state.copyWith(
        status: ImageActionStatus.failure,
        error: e.toString(),
      ));

      rethrow;
    }
  }

  share() async {
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
        )
      ]);

      emit(state.copyWith(status: ImageActionStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: ImageActionStatus.failure,
        error: e.toString(),
      ));

      rethrow;
    }
  }
}
