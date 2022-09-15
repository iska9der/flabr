// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'hub_subscription_cubit.dart';

enum HubSubscriptionStatus { loading, success, failure }

class HubSubscriptionState extends Equatable {
  const HubSubscriptionState({
    this.status = HubSubscriptionStatus.success,
    this.error = '',
    required this.hubAlias,
    this.isSubscribed = false,
  });

  final HubSubscriptionStatus status;
  final String error;
  final String hubAlias;
  final bool isSubscribed;

  HubSubscriptionState copyWith({
    HubSubscriptionStatus? status,
    String? error,
    String? hubAlias,
    bool? isSubscribed,
  }) {
    return HubSubscriptionState(
      status: status ?? this.status,
      error: error ?? this.error,
      hubAlias: hubAlias ?? this.hubAlias,
      isSubscribed: isSubscribed ?? this.isSubscribed,
    );
  }

  String get buttonText => isSubscribed ? 'Подписан' : 'Подписаться';

  @override
  List<Object> get props => [status, error, hubAlias, isSubscribed];
}
