part of 'user_cubit.dart';

enum UserStatus { initial, loading, success, failure }

class UserState extends Equatable {
  const UserState({
    required this.login,
    this.status = UserStatus.initial,
    required this.model,
    this.whoisModel = UserWhois.empty,
  });

  final String login;
  final UserStatus status;
  final User model;
  final UserWhois whoisModel;

  UserState copyWith({
    UserStatus? status,
    User? model,
    UserWhois? whoisModel,
  }) {
    return UserState(
      login: login,
      status: status ?? this.status,
      model: model ?? this.model,
      whoisModel: whoisModel ?? this.whoisModel,
    );
  }

  @override
  List<Object> get props => [
        login,
        status,
        model,
        whoisModel,
      ];
}
