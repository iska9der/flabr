part of 'user_cubit.dart';

class UserState with EquatableMixin {
  const UserState({
    required this.login,
    this.status = .initial,
    this.error = '',
    required this.model,
    this.whoisModel = UserWhois.empty,
  });

  final String login;
  final LoadingStatus status;
  final String error;
  final User model;
  final UserWhois whoisModel;

  UserState copyWith({
    LoadingStatus? status,
    String? error,
    User? model,
    UserWhois? whoisModel,
  }) {
    return UserState(
      login: login,
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
      whoisModel: whoisModel ?? this.whoisModel,
    );
  }

  @override
  List<Object> get props => [login, status, error, model, whoisModel];
}
