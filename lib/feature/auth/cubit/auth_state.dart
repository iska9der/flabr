part of 'auth_cubit.dart';

enum AuthStatus { initial, loading, authorized, unauthorized }

class AuthState extends Equatable {
  const AuthState({
    this.error = '',
    this.status = AuthStatus.initial,
    this.data = AuthDataModel.empty,
    this.csrfToken = '',
    this.me = MeModel.empty,
  });

  final String error;
  final AuthStatus status;
  final AuthDataModel data;
  final String csrfToken;
  final MeModel me;

  AuthState copyWith({
    String? error,
    AuthStatus? status,
    AuthDataModel? data,
    String? csrfToken,
    MeModel? me,
  }) {
    return AuthState(
      error: error ?? this.error,
      status: status ?? this.status,
      data: data ?? this.data,
      csrfToken: csrfToken ?? this.csrfToken,
      me: me ?? this.me,
    );
  }

  bool get isAuthorized => status == AuthStatus.authorized;
  bool get isUnauthorized => status == AuthStatus.unauthorized;

  @override
  List<Object> get props => [
        error,
        status,
        data,
        csrfToken,
        me,
      ];
}
