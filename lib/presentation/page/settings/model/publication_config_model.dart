part of 'config_model.dart';

@freezed
abstract class PublicationConfigModel with _$PublicationConfigModel {
  const PublicationConfigModel._();

  const factory PublicationConfigModel({
    @Default(1) double fontScale,
    @Default(true) bool isImagesVisible,
    @Default(true) bool webViewEnabled,
  }) = _PublicationConfigModel;

  static const empty = PublicationConfigModel();

  factory PublicationConfigModel.fromJson(Map<String, dynamic> json) =>
      _$PublicationConfigModelFromJson(json);
}
