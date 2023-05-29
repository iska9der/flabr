import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/model/extension/state_status_x.dart';
import '../repository/subscription_repository.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit({
    required SubscriptionRepository repository,
    required String alias,
    required bool isSubscribed,
  })  : repo = repository,
        super(SubscriptionState(alias: alias, isSubscribed: isSubscribed));

  final SubscriptionRepository repo;

  void toggleSubscription() async {
    if (state.status.isLoading) return;

    emit(state.copyWith(status: SubscriptionStatus.loading));

    try {
      await repo.toggleSubscription(alias: state.alias);

      emit(state.copyWith(
        status: SubscriptionStatus.success,
        isSubscribed: !state.isSubscribed,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SubscriptionStatus.failure,
        error: 'Не удалось',
      ));
    }
  }
}