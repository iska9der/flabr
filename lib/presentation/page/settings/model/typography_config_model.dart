part of 'config_model.dart';

@freezed
abstract class TypographyConfigModel with _$TypographyConfigModel {
  const TypographyConfigModel._();

  static const double minTextScaleFactor = 1.0;
  static const double maxTextScaleFactor = 1.3;

  const factory TypographyConfigModel({
    @Default(1.0) double textScaleFactor,
    AppTextStyle? publicationTitleStyle,
    AppTextStyle? publicationTextStyle,
  }) = _TypographyConfigModel;

  static const empty = TypographyConfigModel();

  factory TypographyConfigModel.fromJson(Map<String, dynamic> json) =>
      _$TypographyConfigModelFromJson(json);
}
