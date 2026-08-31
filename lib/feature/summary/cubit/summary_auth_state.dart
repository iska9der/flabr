part of 'summary_auth_cubit.dart';

enum SummaryAuthStatus { initial, loading, authorized, unauthorized }

class SummaryAuthState with Equatable {
  const SummaryAuthState({
    this.status = .initial,
    this.token = '',
  });

  final SummaryAuthStatus status;
  final String token;

  SummaryAuthState copyWith({
    SummaryAuthStatus? status,
    String? token,
  }) {
    return SummaryAuthState(
      status: status ?? this.status,
      token: token ?? this.token,
    );
  }

  bool get isAuthorized => status == .authorized;
  bool get isUnauthorized => status != .authorized;

  @override
  List<Object> get props => [status, token];
}
