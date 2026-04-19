part of 'config_model.dart';

enum NavigationAlignment {
  start,
  center,
  end
  ;

  String get label => switch (this) {
    NavigationAlignment.start => 'В начале',
    NavigationAlignment.center => 'В центре',
    NavigationAlignment.end => 'В конце',
  };
}

@freezed
abstract class MiscConfigModel with _$MiscConfigModel {
  const MiscConfigModel._();

  const factory MiscConfigModel({
    @Default(NavigationAlignment.start) NavigationAlignment navigationAlignment,
    @Default(true) bool navigationOnScrollVisible,
    @Default(ScrollVariant.material) ScrollVariant scrollVariant,
  }) = _MiscConfigModel;

  static const empty = MiscConfigModel();

  factory MiscConfigModel.fromJson(Map<String, dynamic> json) =>
      _$MiscConfigModelFromJson(json);
}
