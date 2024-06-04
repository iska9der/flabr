part of 'settings_cubit.dart';

enum SettingsStatus { initial, loading, success, failure }

class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStatus.initial,
    this.langUI = LanguageEnum.ru,
    this.langArticles = const [LanguageEnum.ru],
    this.isDarkTheme = false,
    this.initialDeepLink = '',
    this.publicationConfig = PublicationConfigModel.empty,
    this.feedConfig = FeedConfigModel.empty,
    this.miscConfig = MiscConfigModel.empty,
  });

  final SettingsStatus status;

  /// Язык интерфейса
  final LanguageEnum langUI;

  /// Язык статей
  final List<LanguageEnum> langArticles;
  final bool isDarkTheme;
  final String initialDeepLink;
  final PublicationConfigModel publicationConfig;
  final FeedConfigModel feedConfig;
  final MiscConfigModel miscConfig;

  SettingsState copyWith({
    SettingsStatus? status,
    LanguageEnum? langUI,
    List<LanguageEnum>? langArticles,
    bool? isDarkTheme,
    String? initialDeepLink,
    PublicationConfigModel? publicationConfig,
    FeedConfigModel? feedConfig,
    MiscConfigModel? miscConfig,
  }) {
    return SettingsState(
      status: status ?? this.status,
      langUI: langUI ?? this.langUI,
      langArticles: langArticles ?? this.langArticles,
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      initialDeepLink: initialDeepLink ?? this.initialDeepLink,
      publicationConfig: publicationConfig ?? this.publicationConfig,
      feedConfig: feedConfig ?? this.feedConfig,
      miscConfig: miscConfig ?? this.miscConfig,
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
        publicationConfig,
        feedConfig,
        miscConfig,
      ];
}
