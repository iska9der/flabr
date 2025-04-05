part of 'hub_cubit.dart';

enum HubStatus { initial, loading, success, failure }

class HubState extends Equatable {
  const HubState({
    this.status = HubStatus.initial,
    this.error = '',
    required this.alias,
    this.model = Hub.empty,
    this.profile = HubProfile.empty,
  });

  final HubStatus status;
  final String error;

  final String alias;
  final Hub model;
  final HubProfile profile;

  HubState copyWith({
    HubStatus? status,
    String? error,
    Hub? model,
    HubProfile? profile,
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
