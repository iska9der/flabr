import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

import '../model/article_model.dart';
import '../model/download/format.dart';
import '../model/download/format_converter.dart';

part 'article_download_state.dart';

class ArticleDownloadCubit extends Cubit<ArticleDownloadState> {
  ArticleDownloadCubit({
    required ArticleModel article,
    required ArticleDownloadFormat format,
  })  : converter = ArticleDownloadFormatConverter(
          text: article.textHtml,
          desiredFormat: format,
        ),
        super(ArticleDownloadState(
          articleId: article.id,
          articleTitle: article.titleHtml,
          articleHtmlText: article.textHtml,
          format: format,
        )) {
    _init();
  }

  final String additionalPath = 'articles';
  final ArticleDownloadFormatConverter converter;

  _init() async {
    if (!await FlutterFileDialog.isPickDirectorySupported()) {
      return emit(state.copyWith(status: ArticleDownloadStatus.notSupported));
    }
  }

  pickAndSave() async {
    if (state.status == ArticleDownloadStatus.loading ||
        state.status == ArticleDownloadStatus.notSupported) return;

    try {
      emit(state.copyWith(status: ArticleDownloadStatus.loading));

      final pickedDirectory = await FlutterFileDialog.pickDirectory();
      if (pickedDirectory == null) {
        return emit(state.copyWith(status: ArticleDownloadStatus.initial));
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

      emit(state.copyWith(status: ArticleDownloadStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: ArticleDownloadStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
