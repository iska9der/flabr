import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/model/extension/state_status_x.dart';
import '../repository/hub_repository.dart';

part 'hub_subscription_state.dart';

class HubSubscriptionCubit extends Cubit<HubSubscriptionState> {
  HubSubscriptionCubit({
    required HubRepository repository,
    required String hubAlias,
    required bool isSubscribed,
  })  : _repository = repository,
        super(HubSubscriptionState(
            hubAlias: hubAlias, isSubscribed: isSubscribed));

  final HubRepository _repository;

  void toggleSubscription() async {
    if (state.status.isLoading) return;

    emit(state.copyWith(status: HubSubscriptionStatus.loading));

    try {
      await _repository.toggleSubscription(alias: state.hubAlias);

      emit(state.copyWith(
        status: HubSubscriptionStatus.success,
        isSubscribed: !state.isSubscribed,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HubSubscriptionStatus.failure,
        error: 'Не удалось',
      ));
    }
  }
}
