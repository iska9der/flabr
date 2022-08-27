part of 'user_cubit.dart';

enum UserStatus { initial, loading, success, failure }

class UserState extends Equatable {
  const UserState({
    required this.login,
    this.status = UserStatus.initial,
    this.langUI = LanguageEnum.ru,
    this.langArticles = const [LanguageEnum.ru],
    required this.model,
    this.whoisModel = UserWhoisModel.empty,
  });

  final String login;
  final UserStatus status;
  final LanguageEnum langUI;
  final List<LanguageEnum> langArticles;
  final UserModel model;
  final UserWhoisModel whoisModel;

  UserState copyWith({
    UserStatus? status,
    LanguageEnum? langUI,
    List<LanguageEnum>? langArticles,
    UserModel? model,
    UserWhoisModel? whoisModel,
  }) {
    return UserState(
      login: login,
      status: status ?? this.status,
      langUI: langUI ?? this.langUI,
      langArticles: langArticles ?? this.langArticles,
      model: model ?? this.model,
      whoisModel: whoisModel ?? this.whoisModel,
    );
  }

  @override
  List<Object> get props => [
        login,
        status,
        langUI,
        langArticles,
        model,
        whoisModel,
      ];
}
