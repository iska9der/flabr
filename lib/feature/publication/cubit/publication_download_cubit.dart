import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

import '../model/article/article_model.dart';
import '../model/download/format.dart';
import '../model/download/format_converter.dart';

part 'publication_download_state.dart';

class PublicationDownloadCubit extends Cubit<PublicationDownloadState> {
  PublicationDownloadCubit({
    required ArticleModel article,
    required PublicationDownloadFormat format,
  })  : converter = PublicationTextFormatConverter(
          text: article.textHtml,
          desiredFormat: format,
        ),
        super(PublicationDownloadState(
          articleId: article.id,
          articleTitle: article.titleHtml,
          articleHtmlText: article.textHtml,
          format: format,
        )) {
    _init();
  }

  final String additionalPath = 'articles';
  final PublicationTextFormatConverter converter;

  _init() async {
    if (!await FlutterFileDialog.isPickDirectorySupported()) {
      return emit(
          state.copyWith(status: PublicationDownloadStatus.notSupported));
    }
  }

  pickAndSave() async {
    if (state.status == PublicationDownloadStatus.loading ||
        state.status == PublicationDownloadStatus.notSupported) return;

    try {
      emit(state.copyWith(status: PublicationDownloadStatus.loading));

      final pickedDirectory = await FlutterFileDialog.pickDirectory();
      if (pickedDirectory == null) {
        return emit(state.copyWith(status: PublicationDownloadStatus.initial));
      }

      final text = converter.convert();
      final data = utf8.encode(text);

      await FlutterFileDialog.saveFileToDirectory(
        directory: pickedDirectory,
        data: data,
        mimeType: state.format.mimeType,
        fileName: state.fileName,
        replace: true,
      );

      emit(state.copyWith(status: PublicationDownloadStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: PublicationDownloadStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
