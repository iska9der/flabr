enum ArticleDownloadFormat {
  html,
  markdown;

  String get ext => switch (this) {
        ArticleDownloadFormat.markdown => 'md',
        ArticleDownloadFormat.html => 'html',
      };

  String get mimeType => switch (this) {
        ArticleDownloadFormat.markdown => 'text/markdown',
        ArticleDownloadFormat.html => 'text/html',
      };
}
