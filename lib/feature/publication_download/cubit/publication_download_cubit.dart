import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

import '../../../data/exception/exception.dart';
import '../model/publication_download_format.dart';
import '../service/publication_text_converter.dart';

part 'publication_download_state.dart';

class PublicationDownloadCubit extends Cubit<PublicationDownloadState> {
  PublicationDownloadCubit({
    required String publicationId,
    required String publicationText,
    required PublicationDownloadFormat format,
  }) : _converter = PublicationTextConverter(
         text: publicationText,
         desiredFormat: format,
       ),
       super(
         PublicationDownloadState(
           id: publicationId,
           htmlText: publicationText,
           format: format,
         ),
       ) {
    _init();
  }

  final PublicationTextConverter _converter;

  Future<void> _init() async {
    if (kIsWeb || !await FlutterFileDialog.isPickDirectorySupported()) {
      return emit(
        state.copyWith(status: PublicationDownloadStatus.notSupported),
      );
    }
  }

  Future<void> pickAndSave() async {
    if (state.status == PublicationDownloadStatus.loading ||
        state.status == PublicationDownloadStatus.notSupported) {
      return;
    }

    try {
      emit(state.copyWith(status: PublicationDownloadStatus.loading));

      final pickedDirectory = await FlutterFileDialog.pickDirectory();
      if (pickedDirectory == null) {
        return emit(state.copyWith(status: PublicationDownloadStatus.initial));
      }

      final text = _converter.convert();
      final data = utf8.encode(text);

      await FlutterFileDialog.saveFileToDirectory(
        directory: pickedDirectory,
        data: data,
        mimeType: state.format.mimeType,
        fileName: state.fileName,
        replace: true,
      );

      emit(state.copyWith(status: PublicationDownloadStatus.success));
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: PublicationDownloadStatus.failure,
          error: error.parseException(),
        ),
      );

      super.onError(error, stackTrace);
    }
  }
}
