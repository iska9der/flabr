part of 'login_cubit.dart';

enum LoginStatus { initial, loading, success, failure }

enum LoginFormStatus { valid, invalid }

enum LoginFieldStatus { initial, invalid, valid }

enum AuthFetchType { login, csrf, me, logout }

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.initial,
    this.type = AuthFetchType.login,
    this.error = '',
    this.formStatus = LoginFormStatus.invalid,
    this.login = '',
    this.loginStatus = LoginFieldStatus.initial,
    this.loginError = '',
    this.password = '',
    this.passwordStatus = LoginFieldStatus.initial,
    this.passwordError = '',
  });

  final LoginStatus status;
  final AuthFetchType type;
  final String error;
  final LoginFormStatus formStatus;
  final String login;
  final LoginFieldStatus loginStatus;
  final String loginError;
  final String password;
  final LoginFieldStatus passwordStatus;
  final String passwordError;

  LoginState copyWith({
    LoginStatus? status,
    AuthFetchType? type,
    String? error,
    LoginFormStatus? formStatus,
    String? login,
    LoginFieldStatus? loginStatus,
    String? loginError,
    String? password,
    LoginFieldStatus? passwordStatus,
    String? passwordError,
  }) {
    return LoginState(
      status: status ?? this.status,
      type: type ?? this.type,
      error: error ?? this.error,
      formStatus: formStatus ?? this.formStatus,
      login: login ?? this.login,
      loginStatus: loginStatus ?? this.loginStatus,
      loginError: loginError ?? this.loginError,
      password: password ?? this.password,
      passwordStatus: passwordStatus ?? this.passwordStatus,
      passwordError: passwordError ?? this.passwordError,
    );
  }

  @override
  List<Object> get props => [
        status,
        type,
        error,
        formStatus,
        login,
        loginStatus,
        password,
        passwordStatus,
      ];
}
