import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/model/extension/state_status_x.dart';
import '../service/hub_service.dart';

part 'hub_subscription_state.dart';

class HubSubscriptionCubit extends Cubit<HubSubscriptionState> {
  HubSubscriptionCubit({
    required HubService service,
    required String hubAlias,
    required bool isSubscribed,
  })  : _service = service,
        super(HubSubscriptionState(
            hubAlias: hubAlias, isSubscribed: isSubscribed));

  final HubService _service;

  void toggleSubscription() async {
    if (state.status.isLoading) return;

    emit(state.copyWith(status: HubSubscriptionStatus.loading));

    try {
      await _service.toggleSubscription(alias: state.hubAlias);

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
