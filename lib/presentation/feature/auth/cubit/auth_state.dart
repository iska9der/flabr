part of 'auth_cubit.dart';

enum AuthStatus { initial, loading, authorized, unauthorized, anomaly }

class AuthState extends Equatable {
  const AuthState({
    this.error = '',
    this.status = AuthStatus.initial,
    this.data = AuthDataModel.empty,
    this.me = UserMeModel.empty,
  });

  final String error;
  final AuthStatus status;
  final AuthDataModel data;
  final UserMeModel me;

  AuthState copyWith({
    String? error,
    AuthStatus? status,
    AuthDataModel? data,
    String? csrfToken,
    UserMeModel? me,
  }) {
    return AuthState(
      error: error ?? this.error,
      status: status ?? this.status,
      data: data ?? this.data,
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
        data,
        me,
      ];
}
