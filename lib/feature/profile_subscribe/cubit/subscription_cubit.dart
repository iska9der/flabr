import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/exception/exception.dart';
import '../../../data/model/loading_status_enum.dart';
import '../../../data/repository/repository.dart';
import '../../../presentation/extension/extension.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit({
    required SubscriptionRepository repository,
    required String alias,
    required bool isSubscribed,
  }) : repo = repository,
       super(SubscriptionState(alias: alias, isSubscribed: isSubscribed));

  final SubscriptionRepository repo;

  void toggleSubscription() async {
    if (state.status.isLoading) return;

    emit(state.copyWith(status: LoadingStatus.loading, error: ''));

    try {
      await repo.toggleSubscription(alias: state.alias);

      emit(
        state.copyWith(
          status: LoadingStatus.success,
          isSubscribed: !state.isSubscribed,
        ),
      );
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: LoadingStatus.failure,
          error: error.parseException(),
        ),
      );

      super.onError(error, stackTrace);
    }
  }
}
