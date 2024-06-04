part of 'hub_cubit.dart';

enum HubStatus { initial, loading, success, failure }

class HubState extends Equatable {
  const HubState({
    this.status = HubStatus.initial,
    this.error = '',
    required this.alias,
    this.model = HubModel.empty,
    this.profile = HubProfileModel.empty,
  });

  final HubStatus status;
  final String error;

  final String alias;
  final HubModel model;
  final HubProfileModel profile;

  HubState copyWith({
    HubStatus? status,
    String? error,
    HubModel? model,
    HubProfileModel? profile,
  }) {
    return HubState(
      alias: alias,
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
      profile: profile ?? this.profile,
    );
  }

  @override
  List<Object> get props => [
        status,
        error,
        alias,
        model,
        profile,
      ];
}
