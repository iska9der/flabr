part of 'subscription_cubit.dart';

class SubscriptionState with Equatable {
  const SubscriptionState({
    this.status = LoadingStatus.success,
    this.error = '',
    required this.alias,
    this.isSubscribed = false,
  });

  final LoadingStatus status;
  final Object error;
  final String alias;
  final bool isSubscribed;

  SubscriptionState copyWith({
    LoadingStatus? status,
    Object? error,
    String? alias,
    bool? isSubscribed,
  }) {
    return SubscriptionState(
      status: status ?? this.status,
      error: error ?? this.error,
      alias: alias ?? this.alias,
      isSubscribed: isSubscribed ?? this.isSubscribed,
    );
  }

  @override
  List<Object> get props => [status, error, alias, isSubscribed];
}
