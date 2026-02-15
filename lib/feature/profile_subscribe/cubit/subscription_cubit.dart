import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/exception/exception.dart';
import '../../../data/model/loading_status_enum.dart';
import '../../../data/repository/repository.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit({
    required SubscriptionRepository repository,
    required String alias,
    required bool isSubscribed,
  }) : _repository = repository,
       super(SubscriptionState(alias: alias, isSubscribed: isSubscribed));

  final SubscriptionRepository _repository;

  void toggleSubscription() async {
    if (state.status == .loading) {
      return;
    }

    emit(state.copyWith(status: .loading, error: ''));

    try {
      await _repository.toggleSubscription(alias: state.alias);

      emit(
        state.copyWith(
          status: .success,
          isSubscribed: !state.isSubscribed,
        ),
      );
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: .failure,
          error: error.parseException(),
        ),
      );

      super.onError(error, stackTrace);
    }
  }
}
