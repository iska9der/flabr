// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'publication_download_cubit.dart';

enum PublicationDownloadStatus {
  initial,
  notSupported,
  loading,
  success,
  failure
}

class PublicationDownloadState extends Equatable {
  const PublicationDownloadState({
    this.articleId = '',
    this.articleTitle = '',
    this.articleHtmlText = '',
    this.format = PublicationDownloadFormat.html,
    this.status = PublicationDownloadStatus.initial,
    this.error = '',
  });

  final String articleId;
  final String articleTitle;
  final String articleHtmlText;
  final PublicationDownloadFormat format;
  final PublicationDownloadStatus status;
  final String error;

  String get fileName => '$articleId.${format.ext}';

  PublicationDownloadState copyWith({
    String? error,
    PublicationDownloadStatus? status,
  }) {
    return PublicationDownloadState(
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
