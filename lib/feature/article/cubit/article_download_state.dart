// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'article_download_cubit.dart';

enum ArticleDownloadStatus { initial, notSupported, loading, success, failure }

class ArticleDownloadState extends Equatable {
  const ArticleDownloadState({
    this.articleId = '',
    this.articleTitle = '',
    this.articleHtmlText = '',
    this.format = ArticleDownloadFormat.html,
    this.status = ArticleDownloadStatus.initial,
    this.error = '',
  });

  final String articleId;
  final String articleTitle;
  final String articleHtmlText;
  final ArticleDownloadFormat format;
  final ArticleDownloadStatus status;
  final String error;

  String get fileName => '$articleId.${format.ext}';

  ArticleDownloadState copyWith({
    String? error,
    ArticleDownloadStatus? status,
  }) {
    return ArticleDownloadState(
      articleId: articleId,
      articleTitle: articleTitle,
      articleHtmlText: articleHtmlText,
      format: format,
      error: error ?? this.error,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        articleId,
        articleTitle,
        articleHtmlText,
        format,
        status,
        error,
      ];
}
