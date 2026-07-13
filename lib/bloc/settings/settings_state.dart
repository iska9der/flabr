part of 'settings_cubit.dart';

class SettingsState with Equatable {
  const SettingsState({
    this.status = .initial,
    this.langUI = .ru,
    this.langArticles = const [.ru],
    this.theme = .empty,
    this.publication = .empty,
    this.feed = .empty,
    this.misc = .empty,
    this.typography = .empty,
  });

  final LoadingStatus status;

  /// Язык интерфейса
  final Language langUI;

  /// Язык статей
  final List<Language> langArticles;

  /// Конфиги
  final ThemeConfigModel theme;
  final PublicationConfigModel publication;
  final FeedConfigModel feed;
  final MiscConfigModel misc;
  final TypographyConfigModel typography;

  SettingsState copyWith({
    LoadingStatus? status,
    Language? langUI,
    List<Language>? langArticles,
    ThemeConfigModel? theme,
    PublicationConfigModel? publication,
    FeedConfigModel? feed,
    MiscConfigModel? misc,
    TypographyConfigModel? typography,
  }) {
    return SettingsState(
      status: status ?? this.status,
      langUI: langUI ?? this.langUI,
      langArticles: langArticles ?? this.langArticles,
      theme: theme ?? this.theme,
      publication: publication ?? this.publication,
      feed: feed ?? this.feed,
      misc: misc ?? this.misc,
      typography: typography ?? this.typography,
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
    typography,
  ];
}
