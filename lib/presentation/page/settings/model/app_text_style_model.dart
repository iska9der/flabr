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

  AppTextStyle merge(AppTextStyle? other) {
    if (other == null) {
      return this;
    }

    return copyWith(
      family: other.family ?? family,
      size: other.size ?? size,
      height: other.height ?? height,
    );
  }

  factory AppTextStyle.fromJson(Map<String, dynamic> json) =>
      _$AppTextStyleFromJson(json);
}
