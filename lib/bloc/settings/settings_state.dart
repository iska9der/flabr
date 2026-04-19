part of 'settings_cubit.dart';

class SettingsState with EquatableMixin {
  const SettingsState({
    this.status = .initial,
    this.langUI = .ru,
    this.langArticles = const [.ru],
    this.theme = .empty,
    this.publication = .empty,
    this.feed = .empty,
    this.misc = .empty,
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

  SettingsState copyWith({
    LoadingStatus? status,
    Language? langUI,
    List<Language>? langArticles,
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
