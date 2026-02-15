part of 'summary_auth_cubit.dart';

enum SummaryAuthStatus { initial, loading, authorized, unauthorized }

class SummaryAuthState with EquatableMixin {
  const SummaryAuthState({
    this.error = '',
    this.status = SummaryAuthStatus.initial,
    this.token = '',
  });

  final String error;
  final SummaryAuthStatus status;
  final String token;

  SummaryAuthState copyWith({
    String? error,
    SummaryAuthStatus? status,
    String? token,
  }) {
    return SummaryAuthState(
      error: error ?? this.error,
      status: status ?? this.status,
      token: token ?? this.token,
    );
  }

  bool get isAuthorized => status == SummaryAuthStatus.authorized;
  bool get isUnauthorized => status != SummaryAuthStatus.authorized;

  @override
  List<Object> get props => [
        error,
        status,
        token,
      ];
}
