import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

import '../../../core/component/html_asset/html_asset.dart';
import '../../../data/exception/exception.dart';
import '../model/publication_download_format.dart';
import '../service/publication_text_converter.dart';

part 'publication_download_state.dart';

/// Управляет выбором каталога и экспортом публикации в выбранном формате
class PublicationDownloadCubit extends Cubit<PublicationDownloadState> {
  PublicationDownloadCubit({
    required String publicationId,
    required String publicationText,
    required PublicationDownloadFormat format,
    required HtmlAssetService assetService,
  }) : _assetService = assetService,
       super(
         PublicationDownloadState(
           id: publicationId,
           htmlText: publicationText,
           format: format,
         ),
       ) {
    _init();
  }

  final HtmlAssetService _assetService;

  Future<void> _init() async {
    if (kIsWeb || !await FlutterFileDialog.isPickDirectorySupported()) {
      return emit(state.copyWith(status: .notSupported));
    }
  }

  /// Запрашивает каталог и сохраняет публикацию вместе с доступными ассетами
  ///
  /// HTML получает встроенные data URI, а Markdown сохраняет ассеты отдельными
  /// файлами с относительными ссылками
  Future<void> pickAndSave() async {
    if (state.status == .loading || state.status == .notSupported) {
      return;
    }

    try {
      emit(state.copyWith(status: .loading));

      final pickedDirectory = await FlutterFileDialog.pickDirectory();
      if (pickedDirectory == null) {
        return emit(state.copyWith(status: .initial));
      }

      final pickedFormat = state.format;

      final isEmbedded = switch (pickedFormat) {
        .html => true,
        _ => false,
      };
      final embeddedTarget = switch (isEmbedded) {
        true => HtmlAssetTarget.embedded(
          path: 'publication_export/${state.id}',
        ),
        false => null,
      };
      final target =
          embeddedTarget ??
          HtmlAssetTarget.uri(
            parent: Uri.parse(pickedDirectory.toString()),
            path: '${state.id}_assets',
          );

      try {
        final htmlWithAssets = await _assetService.saveHtml(
          html: state.htmlText,
          target: target,
        );
        final text = PublicationTextConverter.convert(
          text: htmlWithAssets,
          format: pickedFormat,
        );
        final data = utf8.encode(text);

        await FlutterFileDialog.saveFileToDirectory(
          directory: pickedDirectory,
          data: data,
          mimeType: pickedFormat.mimeType,
          fileName: state.fileName,
          replace: true,
        );
      } finally {
        if (embeddedTarget != null) {
          await _assetService.delete(embeddedTarget);
        }
      }

      emit(state.copyWith(status: .success));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: .failure, error: error.parseException()));

      super.onError(error, stackTrace);
    }
  }
}
