enum PublicationDownloadFormat {
  html,
  markdown;

  String get ext => switch (this) {
        PublicationDownloadFormat.markdown => 'md',
        PublicationDownloadFormat.html => 'html',
      };

  String get mimeType => switch (this) {
        PublicationDownloadFormat.markdown => 'text/markdown',
        PublicationDownloadFormat.html => 'text/html',
      };
}
