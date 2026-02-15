part of 'login_cubit.dart';

class LoginState with EquatableMixin {
  const LoginState({
    this.status = LoadingStatus.initial,
    this.error = '',
  });

  final LoadingStatus status;
  final String error;

  LoginState copyWith({
    LoadingStatus? status,
    String? error,
  }) {
    return LoginState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [
    status,
    error,
  ];
}
