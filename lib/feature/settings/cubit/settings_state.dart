part of 'settings_cubit.dart';

enum SettingsStatus { initial, loading, success, failure }

class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStatus.initial,
    this.isDarkTheme = false,
  });

  final SettingsStatus status;
  final bool isDarkTheme;

  SettingsState copyWith({
    SettingsStatus? status,
    bool? isDarkTheme,
  }) {
    return SettingsState(
      status: status ?? this.status,
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [status, isDarkTheme];
}
