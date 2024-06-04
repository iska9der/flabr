part of 'user_cubit.dart';

enum UserStatus { initial, loading, success, failure }

class UserState extends Equatable {
  const UserState({
    required this.login,
    this.status = UserStatus.initial,
    required this.model,
    this.whoisModel = UserWhoisModel.empty,
  });

  final String login;
  final UserStatus status;
  final UserModel model;
  final UserWhoisModel whoisModel;

  UserState copyWith({
    UserStatus? status,
    UserModel? model,
    UserWhoisModel? whoisModel,
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
