part of 'config_model.dart';

@freezed
class ThemeConfigModel with _$ThemeConfigModel {
  const ThemeConfigModel._();

  const factory ThemeConfigModel({
    @Default(false) bool isDarkTheme,
  }) = _ThemeConfigModel;

  static const empty = ThemeConfigModel();

  ThemeMode get mode => switch (isDarkTheme) {
        true => ThemeMode.dark,
        false => ThemeMode.light,
      };

  factory ThemeConfigModel.fromJson(Map<String, dynamic> json) =>
      _$ThemeConfigModelFromJson(json);
}
