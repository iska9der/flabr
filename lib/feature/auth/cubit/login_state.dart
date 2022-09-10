part of 'login_cubit.dart';

enum LoginStatus { initial, loading, success, failure }

enum AuthFetchType { login, csrf, me, logout }

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.initial,
    this.type = AuthFetchType.login,
    this.error = '',
    this.login = '',
    this.password = '',
  });

  final LoginStatus status;
  final AuthFetchType type;
  final String error;
  final String login;
  final String password;

  LoginState copyWith({
    LoginStatus? status,
    AuthFetchType? type,
    String? error,
    String? login,
    String? password,
  }) {
    return LoginState(
      status: status ?? this.status,
      type: type ?? this.type,
      error: error ?? this.error,
      login: login ?? this.login,
      password: password ?? this.password,
    );
  }

  @override
  List<Object> get props => [status, type, error, login, password];
}
