// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/model/extension/enum_status.dart';
import '../../../../common/utils/utils.dart';
import '../../../../component/di/injector.dart';
import '../cubit/subscription_cubit.dart';
import '../repository/subscription_repository.dart';

class SubscribeButton extends StatelessWidget {
  const SubscribeButton(
      {super.key, required this.alias, required this.isSubscribed});

  final String alias;
  final bool isSubscribed;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubscriptionCubit(
        repository: getIt.get<SubscriptionRepository>(),
        alias: alias,
        isSubscribed: isSubscribed,
      ),
      child: BlocListener<SubscriptionCubit, SubscriptionState>(
        listenWhen: (p, c) => p.status.isFailure,
        listener: (context, state) {
          getIt.get<Utils>().showSnack(
                context: context,
                content: Text(state.error),
              );
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
              onPressed: state.status.isLoading
                  ? null
                  : () =>
                      context.read<SubscriptionCubit>().toggleSubscription(),
              child: Text(state.buttonText),
            );
          },
        ),
      ),
    );
  }
}
