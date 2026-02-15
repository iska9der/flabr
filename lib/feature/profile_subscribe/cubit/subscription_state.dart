part of 'subscription_cubit.dart';

class SubscriptionState with EquatableMixin {
  const SubscriptionState({
    this.status = LoadingStatus.success,
    this.error = '',
    required this.alias,
    this.isSubscribed = false,
  });

  final LoadingStatus status;
  final String error;
  final String alias;
  final bool isSubscribed;

  SubscriptionState copyWith({
    LoadingStatus? status,
    String? error,
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

  String get buttonText => isSubscribed ? 'Подписан' : 'Подписаться';

  @override
  List<Object> get props => [status, error, alias, isSubscribed];
}
