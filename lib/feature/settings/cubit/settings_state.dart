part of 'settings_cubit.dart';

enum SettingsStatus { initial, loading, success, failure }

class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStatus.initial,
    this.isDarkTheme = false,
    this.initialDeepLink = '/',
  });

  final SettingsStatus status;
  final bool isDarkTheme;
  final String initialDeepLink;

  SettingsState copyWith({
    SettingsStatus? status,
    bool? isDarkTheme,
    String? initialDeepLink,
  }) {
    return SettingsState(
      status: status ?? this.status,
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      initialDeepLink: initialDeepLink ?? this.initialDeepLink,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [status, isDarkTheme, initialDeepLink];
}
