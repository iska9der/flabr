part of 'image_download_cubit.dart';

enum ImageDownloadStatus { initial, notSupported, loading, success, failure }

class ImageDownloadState extends Equatable {
  const ImageDownloadState({
    required this.url,
    this.savePath = '',
    this.status = ImageDownloadStatus.initial,
    this.error = '',
  });

  final String url;
  final String savePath;
  final ImageDownloadStatus status;
  final String error;

  ImageDownloadState copyWith({
    String? error,
    ImageDownloadStatus? status,
    String? savePath,
  }) {
    return ImageDownloadState(
      url: url,
      error: error ?? this.error,
      status: status ?? this.status,
      savePath: savePath ?? this.savePath,
    );
  }

  @override
  List<Object> get props => [
        url,
        savePath,
        status,
        error,
      ];
}
