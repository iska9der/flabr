part of '../part.dart';

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
        error: ExceptionHelper.parseMessage(e, 'Не удалось'),
      ));
    }
  }
}
