part of 'config_model.dart';

@freezed
abstract class PublicationConfigModel with _$PublicationConfigModel {
  const PublicationConfigModel._();

  const factory PublicationConfigModel({
    @Default(defaultScale) double fontScale,
    @Default(true) bool isImagesVisible,
    @Default(true) bool webViewEnabled,
  }) = _PublicationConfigModel;

  static const double defaultScale = 1.0;
  static const empty = PublicationConfigModel();

  factory PublicationConfigModel.fromJson(Map<String, dynamic> json) =>
      _$PublicationConfigModelFromJson(json);
}
