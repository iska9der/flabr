part of 'auth_cubit.dart';

enum AuthStatus { initial, loading, authorized, unauthorized, anomaly }

class AuthState extends Equatable {
  const AuthState({
    this.error = '',
    this.status = AuthStatus.initial,
    this.tokens = Tokens.empty,
    this.me = UserMe.empty,
  });

  final String error;
  final AuthStatus status;
  final Tokens tokens;
  final UserMe me;

  AuthState copyWith({
    String? error,
    AuthStatus? status,
    Tokens? tokens,
    String? csrfToken,
    UserMe? me,
  }) {
    return AuthState(
      error: error ?? this.error,
      status: status ?? this.status,
      tokens: tokens ?? this.tokens,
      me: me ?? this.me,
    );
  }

  bool get isAuthorized => status == AuthStatus.authorized;
  bool get isUnauthorized => status == AuthStatus.unauthorized;
  bool get isAnomaly => status == AuthStatus.anomaly;

  @override
  List<Object> get props => [
        error,
        status,
        tokens,
        me,
      ];
}
