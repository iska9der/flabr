part of 'config_model.dart';

enum NavigationAlignment {
  start,
  center,
  end;

  String get label => switch (this) {
    NavigationAlignment.start =>
      t.settings.interface.navigation.alignment.start,
    NavigationAlignment.center =>
      t.settings.interface.navigation.alignment.center,
    NavigationAlignment.end => t.settings.interface.navigation.alignment.end,
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
