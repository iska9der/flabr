part of 'config_model.dart';

@freezed
abstract class FeedConfigModel with _$FeedConfigModel {
  const FeedConfigModel._();

  const factory FeedConfigModel({
    @Default(true) bool isImageVisible,
    @Default(false) bool isDescriptionVisible,
    AppTextStyle? titleStyle,
  }) = _FeedConfigModel;

  static const empty = FeedConfigModel();

  factory FeedConfigModel.fromJson(Map<String, dynamic> json) =>
      _$FeedConfigModelFromJson(json);
}
