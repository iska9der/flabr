part of 'user_cubit.dart';

enum UserStatus { initial, loading, success, failure }

class UserState extends Equatable {
  const UserState({
    required this.login,
    this.status = UserStatus.initial,
    required this.model,
  });

  final String login;
  final UserStatus status;
  final UserModel model;

  UserState copyWith({UserStatus? status, UserModel? model}) {
    return UserState(
      login: login,
      status: status ?? this.status,
      model: model ?? this.model,
    );
  }

  @override
  List<Object> get props => [login, status, model];
}
