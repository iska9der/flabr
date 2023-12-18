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
    this.id = '',
    this.htmlText = '',
    this.format = PublicationDownloadFormat.html,
    this.status = PublicationDownloadStatus.initial,
    this.error = '',
  });

  final String id;
  final String htmlText;
  final PublicationDownloadFormat format;
  final PublicationDownloadStatus status;
  final String error;

  String get fileName => '$id.${format.ext}';

  PublicationDownloadState copyWith({
    String? error,
    PublicationDownloadStatus? status,
  }) {
    return PublicationDownloadState(
      id: id,
      htmlText: htmlText,
      format: format,
      error: error ?? this.error,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        id,
        htmlText,
        format,
        status,
        error,
      ];
}
