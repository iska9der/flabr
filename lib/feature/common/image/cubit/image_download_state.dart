part of 'image_download_cubit.dart';

enum ImageDownloadStatus { initial, notSupported, loading, success, failure }

class ImageDownloadState extends Equatable {
  const ImageDownloadState({
    required this.url,
    this.status = ImageDownloadStatus.initial,
    this.error = '',
  });

  final String url;
  final ImageDownloadStatus status;
  final String error;

  ImageDownloadState copyWith({
    String? error,
    ImageDownloadStatus? status,
  }) {
    return ImageDownloadState(
      url: url,
      error: error ?? this.error,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        url,
        status,
        error,
      ];
}
