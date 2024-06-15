part of 'settings_cubit.dart';

enum SettingsStatus { initial, loading, success, failure }

class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStatus.initial,
    this.langUI = LanguageEnum.ru,
    this.langArticles = const [LanguageEnum.ru],
    this.theme = ThemeConfigModel.empty,
    this.publication = PublicationConfigModel.empty,
    this.feed = FeedConfigModel.empty,
    this.misc = MiscConfigModel.empty,
  });

  final SettingsStatus status;

  /// Язык интерфейса
  final LanguageEnum langUI;

  /// Язык статей
  final List<LanguageEnum> langArticles;

  /// Конфиги
  final ThemeConfigModel theme;
  final PublicationConfigModel publication;
  final FeedConfigModel feed;
  final MiscConfigModel misc;

  SettingsState copyWith({
    SettingsStatus? status,
    LanguageEnum? langUI,
    List<LanguageEnum>? langArticles,
    ThemeConfigModel? theme,
    PublicationConfigModel? publication,
    FeedConfigModel? feed,
    MiscConfigModel? misc,
  }) {
    return SettingsState(
      status: status ?? this.status,
      langUI: langUI ?? this.langUI,
      langArticles: langArticles ?? this.langArticles,
      theme: theme ?? this.theme,
      publication: publication ?? this.publication,
      feed: feed ?? this.feed,
      misc: misc ?? this.misc,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        status,
        langUI,
        langArticles,
        theme,
        publication,
        feed,
        misc,
      ];
}
