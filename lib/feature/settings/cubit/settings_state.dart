part of 'settings_cubit.dart';

enum SettingsStatus { initial, loading, success, failure }

class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStatus.initial,
    this.langUI = LanguageEnum.ru,
    this.langArticles = const [LanguageEnum.ru],
    this.isDarkTheme = false,
    this.initialDeepLink = '',
    this.articleConfig = ArticleConfigModel.empty,
  });

  final SettingsStatus status;

  /// Язык интерфейса
  final LanguageEnum langUI;

  /// Язык статей
  final List<LanguageEnum> langArticles;
  final bool isDarkTheme;
  final String initialDeepLink;
  final ArticleConfigModel articleConfig;

  SettingsState copyWith({
    SettingsStatus? status,
    LanguageEnum? langUI,
    List<LanguageEnum>? langArticles,
    bool? isDarkTheme,
    String? initialDeepLink,
    ArticleConfigModel? articleConfig,
  }) {
    return SettingsState(
      status: status ?? this.status,
      langUI: langUI ?? this.langUI,
      langArticles: langArticles ?? this.langArticles,
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      initialDeepLink: initialDeepLink ?? this.initialDeepLink,
      articleConfig: articleConfig ?? this.articleConfig,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        status,
        langUI,
        langArticles,
        isDarkTheme,
        initialDeepLink,
        articleConfig,
      ];
}
