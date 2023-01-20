// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/model/extension/state_status_x.dart';
import '../../../common/utils/utils.dart';
import '../../../component/di/dependencies.dart';
import '../cubit/hub_cubit.dart';
import '../cubit/hub_subscription_cubit.dart';
import '../model/hub_related_data.dart';
import '../repository/hub_repository.dart';

class HubSubscribeButton extends StatelessWidget {
  const HubSubscribeButton({Key? key, this.child}) : super(key: key);

  /// Если хочется изменить вид кнопки - передаем в child, и тогда этот виджет
  /// (`HubSubscribeButton`) будет лишь оболочкой, в которой создается
  /// кубит для вашего chukd.
  ///
  /// Не забудь обернуть child в `BlocBuilder<HubSubscriptionCubit, HubSubscriptionState>`
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final hubCubit = context.read<HubCubit>();

    return BlocProvider(
      create: (_) => HubSubscriptionCubit(
        repository: getIt.get<HubRepository>(),
        hubAlias: hubCubit.state.alias,
        isSubscribed:
            (hubCubit.state.profile.relatedData as HubRelatedData).isSubscribed,
      ),
      child: BlocListener<HubSubscriptionCubit, HubSubscriptionState>(
        listenWhen: (p, c) => p.status.isFailure,
        listener: (context, state) {
          getIt.get<Utils>().showNotification(
                context: context,
                content: Text(state.error),
              );
        },
        child: child ??
            BlocBuilder<HubSubscriptionCubit, HubSubscriptionState>(
              builder: (context, state) {
                var style = const ButtonStyle();

                if (state.isSubscribed) {
                  style = style.copyWith(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  );
                }

                return ElevatedButton(
                  style: style,
                  onPressed: state.status.isLoading
                      ? null
                      : () => context
                          .read<HubSubscriptionCubit>()
                          .toggleSubscription(),
                  child: Text(state.buttonText),
                );
              },
            ),
      ),
    );
  }
}
