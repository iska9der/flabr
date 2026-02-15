part of 'image_action_cubit.dart';

enum ImageActionStatus { initial, loading, success, failure }

class ImageActionState with EquatableMixin {
  const ImageActionState({
    this.status = ImageActionStatus.initial,
    this.error = '',
    this.isSaveEnabled = true,
    this.isShareEnabled = true,
    required this.url,
    this.name = '',
    this.mimeType = '',
    this.bytes,
  });

  final ImageActionStatus status;
  final String error;
  final bool isSaveEnabled;
  final bool isShareEnabled;

  final String url;
  final String name;
  final String mimeType;
  final Uint8List? bytes;

  bool get canSave => isSaveEnabled && status != ImageActionStatus.loading;
  bool get canShare => isShareEnabled && status != ImageActionStatus.loading;

  ImageActionState copyWith({
    String? error,
    ImageActionStatus? status,
    bool? isSaveEnabled,
    bool? isShareEnabled,
    String? name,
    String? mimeType,
    Uint8List? bytes,
  }) {
    return ImageActionState(
      status: status ?? this.status,
      error: error ?? this.error,
      isSaveEnabled: isSaveEnabled ?? this.isSaveEnabled,
      isShareEnabled: isShareEnabled ?? this.isShareEnabled,
      url: url,
      name: name ?? this.name,
      mimeType: mimeType ?? this.mimeType,
      bytes: bytes ?? this.bytes,
    );
  }

  @override
  List<Object?> get props => [
    status,
    error,
    isSaveEnabled,
    isShareEnabled,
    url,
    name,
    mimeType,
    bytes,
  ];
}
