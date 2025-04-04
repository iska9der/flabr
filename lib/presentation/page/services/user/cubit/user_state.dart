part of 'user_cubit.dart';

enum UserStatus { initial, loading, success, failure }

class UserState extends Equatable {
  const UserState({
    required this.login,
    this.status = UserStatus.initial,
    this.error = '',
    required this.model,
    this.whoisModel = UserWhois.empty,
  });

  final String login;
  final UserStatus status;
  final String error;
  final User model;
  final UserWhois whoisModel;

  UserState copyWith({
    UserStatus? status,
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
