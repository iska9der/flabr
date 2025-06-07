part of 'auth_cubit.dart';

enum AuthStatus { initial, loading, authorized, unauthorized, anomaly }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.error = '',
    this.token = '',
    this.me = UserMe.empty,
    this.updates = const UserUpdates(),
  });

  final AuthStatus status;
  final String error;
  final String token;
  final UserMe me;
  final UserUpdates updates;

  AuthState copyWith({
    AuthStatus? status,
    String? error,
    String? token,
    UserMe? me,
    UserUpdates? updates,
  }) {
    return AuthState(
      error: error ?? this.error,
      status: status ?? this.status,
      token: token ?? this.token,
      me: me ?? this.me,
      updates: updates ?? this.updates,
    );
  }

  bool get isAuthorized => status == AuthStatus.authorized;
  bool get isUnauthorized => status == AuthStatus.unauthorized;
  bool get isAnomaly => status == AuthStatus.anomaly;

  @override
  List<Object> get props => [error, status, token, me, updates];
}
