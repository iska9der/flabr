part of 'config_model.dart';

@freezed
abstract class ThemeConfigModel with _$ThemeConfigModel {
  const ThemeConfigModel._();

  const factory ThemeConfigModel({
    @Deprecated('теперь используется mode. Удалить в 1.3.0') bool? isDarkTheme,
    @Default(ThemeMode.system) ThemeMode mode,
  }) = _ThemeConfigModel;

  static const empty = ThemeConfigModel();

  ThemeMode? get modeByBool => switch (isDarkTheme) {
    true => ThemeMode.dark,
    false => ThemeMode.light,
    _ => null,
  };

  factory ThemeConfigModel.fromJson(Map<String, dynamic> json) =>
      _$ThemeConfigModelFromJson(json);
}
