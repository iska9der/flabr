part of 'config_model.dart';

@freezed
abstract class MiscConfigModel with _$MiscConfigModel {
  const MiscConfigModel._();

  const factory MiscConfigModel({
    @Default(true) bool navigationOnScrollVisible,
    @Default(ScrollVariant.material) ScrollVariant scrollVariant,
  }) = _MiscConfigModel;

  static const empty = MiscConfigModel();

  factory MiscConfigModel.fromJson(Map<String, dynamic> json) =>
      _$MiscConfigModelFromJson(json);
}
