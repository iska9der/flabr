import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:share_plus/share_plus.dart';

import '../../../bloc/error/app_failure.dart';
import '../service/image_loader.dart';

part 'image_action_state.dart';

class ImageActionCubit extends Cubit<ImageActionState> {
  ImageActionCubit({required this._loader, required String url})
    : super(ImageActionState(url: url)) {
    _init();
  }

  final ImageLoader _loader;

  Future<void> _init() async {
    if (state.url.isEmpty) {
      return emit(state.copyWith(isSaveEnabled: false));
    }

    if (kIsWeb || !await FlutterFileDialog.isPickDirectorySupported()) {
      return emit(state.copyWith(isSaveEnabled: false));
    }
  }

  Future<void> _loadImage() async {
    if (state.bytes != null) return;

    final image = await _loader.load(state.url);

    emit(
      state.copyWith(
        name: image.name,
        mimeType: image.mimeType,
        bytes: image.bytes,
      ),
    );
  }

  Future<void> pickAndSave() async {
    if (state.status == .loading || !state.isSaveEnabled) {
      return;
    }

    try {
      emit(state.copyWith(status: .loading));

      final pickedDirectory = await FlutterFileDialog.pickDirectory();
      if (pickedDirectory == null) {
        return emit(state.copyWith(status: .initial));
      }

      await _loadImage();

      await FlutterFileDialog.saveFileToDirectory(
        directory: pickedDirectory,
        data: state.bytes!,
        fileName: state.name,
        mimeType: state.mimeType,
        replace: true,
      );

      emit(state.copyWith(status: .success));
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: .failure,
          error: AppFailure(.operationFailed, error),
        ),
      );

      super.onError(error, stackTrace);
    }
  }

  Future<void> share() async {
    if (state.status == .loading || !state.isShareEnabled) {
      return;
    }

    try {
      emit(state.copyWith(status: .loading));

      await _loadImage();

      await SharePlus.instance.share(
        ShareParams(
          files: [
            .fromData(state.bytes!, name: state.name, mimeType: state.mimeType),
          ],
        ),
      );

      emit(state.copyWith(status: .success));
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: .failure,
          error: AppFailure(.operationFailed, error),
        ),
      );

      super.onError(error, stackTrace);
    }
  }
}
