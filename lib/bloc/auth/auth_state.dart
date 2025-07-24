part of 'auth_cubit.dart';

enum AuthStatus { initial, loading, authorized, unauthorized }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.error = '',
    this.token = '',
  });

  final AuthStatus status;
  final String error;
  final String token;

  AuthState copyWith({
    AuthStatus? status,
    String? error,
    String? token,
  }) {
    return AuthState(
      error: error ?? this.error,
      status: status ?? this.status,
      token: token ?? this.token,
    );
  }

  bool get isAuthorized => status == AuthStatus.authorized;
  bool get isUnauthorized => status == AuthStatus.unauthorized;

  @override
  List<Object> get props => [error, status, token];
}
