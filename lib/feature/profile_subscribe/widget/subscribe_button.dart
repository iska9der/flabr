import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/component/di/di.dart';
import '../../../data/model/loading_status_enum.dart';
import '../../../presentation/extension/extension.dart';
import '../cubit/subscription_cubit.dart';

class SubscribeButton extends StatelessWidget {
  const SubscribeButton({
    super.key,
    required this.alias,
    required this.isSubscribed,
  });

  final String alias;
  final bool isSubscribed;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => SubscriptionCubit(
            repository: getIt(),
            alias: alias,
            isSubscribed: isSubscribed,
          ),
      child: BlocListener<SubscriptionCubit, SubscriptionState>(
        listenWhen: (p, c) => p.status == LoadingStatus.failure,
        listener: (context, state) {
          context.showSnack(content: Text(state.error));
        },
        child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
          builder: (context, state) {
            var style = const ButtonStyle();

            if (state.isSubscribed) {
              style = style.copyWith(
                foregroundColor: WidgetStateProperty.all(Colors.white),
                backgroundColor: WidgetStateProperty.all(Colors.green),
              );
            }

            return OutlinedButton(
              style: style,
              onPressed:
                  state.status == LoadingStatus.loading
                      ? null
                      : () =>
                          context
                              .read<SubscriptionCubit>()
                              .toggleSubscription(),
              child: Text(state.buttonText),
            );
          },
        ),
      ),
    );
  }
}
