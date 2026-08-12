import 'package:html2md/html2md.dart' as html2md;

import '../model/publication_download_format.dart';

/// Преобразует HTML публикации в формат, выбранный для экспорта
abstract final class PublicationTextConverter {
  /// Возвращает полноценный HTML-документ или Markdown-текст
  static String convert({
    required String text,
    required PublicationDownloadFormat format,
  }) {
    return switch (format) {
      .html => _foldHtml(text),
      .markdown => html2md.convert(text),
    };
  }

  static String _foldHtml(String body) {
    final String html =
        '''
      <html>
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width,initial-scale=1.0,viewport-fit=cover,maximum-scale=1,user-scalable=0">
          <style>
            img {
              display: block;
              max-width: 100%;
              height: auto;
            }
          </style>
        </head>
        <body>$body</body>
      </html>
     ''';

    return html;
  }
}
