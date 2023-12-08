import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';

import '../../../component/logger/console.dart';
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
    try {
      if (!await FlutterFileDialog.isPickDirectorySupported()) {
        return emit(state.copyWith(status: ArticleDownloadStatus.notSupported));
      }

      final path = (await getTemporaryDirectory()).path;
      final articlesDir = await Directory('$path/$additionalPath').create();
      logger.info(articlesDir.path, title: 'Path to save');

      emit(state.copyWith(savePath: articlesDir.path));
    } catch (e) {
      emit(state.copyWith(
        status: ArticleDownloadStatus.failure,
        error: e.toString(),
      ));
    }
  }

  pickAndSave() async {
    if (state.status == ArticleDownloadStatus.notSupported) return;

    try {
      emit(state.copyWith(status: ArticleDownloadStatus.loading));

      final pickedDirectory = await FlutterFileDialog.pickDirectory();
      if (pickedDirectory == null) {
        return emit(state.copyWith(status: ArticleDownloadStatus.initial));
      }

      String path = '${state.savePath}/${state.fileName}';
      String text = converter.convert();
      File file = await File(path).writeAsString(text);

      await FlutterFileDialog.saveFileToDirectory(
        directory: pickedDirectory,
        data: file.readAsBytesSync(),
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
