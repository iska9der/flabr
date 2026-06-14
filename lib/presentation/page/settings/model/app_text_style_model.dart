part of 'config_model.dart';

@freezed
abstract class AppTextStyle with _$AppTextStyle {
  const AppTextStyle._();

  const factory AppTextStyle({
    String? family,
    double? size,
    double? height,
  }) = _AppTextStyle;

  static const empty = AppTextStyle();

  factory AppTextStyle.fromJson(Map<String, dynamic> json) =>
      _$AppTextStyleFromJson(json);
}
