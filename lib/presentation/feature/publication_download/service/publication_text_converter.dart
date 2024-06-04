part of '../part.dart';

class PublicationTextConverter {
  PublicationTextConverter({
    required this.text,
    required this.desiredFormat,
  });

  final String text;
  final PublicationDownloadFormat desiredFormat;

  String convert() {
    switch (desiredFormat) {
      case PublicationDownloadFormat.html:
        return _foldHtml(text);
      case PublicationDownloadFormat.markdown:
        return html2md.convert(text);
    }
  }

  String _foldHtml(String body) {
    final String html = '''
      <html>
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width,initial-scale=1.0,viewport-fit=cover,maximum-scale=1,user-scalable=0">
        </head>
        <body>$body</body>
      </html>
     ''';

    return html;
  }
}
