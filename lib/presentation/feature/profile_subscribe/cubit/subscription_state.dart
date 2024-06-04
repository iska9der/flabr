part of '../part.dart';

enum SubscriptionStatus { loading, success, failure }

class SubscriptionState extends Equatable {
  const SubscriptionState({
    this.status = SubscriptionStatus.success,
    this.error = '',
    required this.alias,
    this.isSubscribed = false,
  });

  final SubscriptionStatus status;
  final String error;
  final String alias;
  final bool isSubscribed;

  SubscriptionState copyWith({
    SubscriptionStatus? status,
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
