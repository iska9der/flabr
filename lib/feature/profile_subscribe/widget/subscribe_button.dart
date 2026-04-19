import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/auth/auth_cubit.dart';
import '../../../data/model/loading_status_enum.dart';
import '../../../di/di.dart';
import '../../../presentation/extension/extension.dart';
import '../../../presentation/widget/dialog/dialog.dart';
import '../cubit/subscription_cubit.dart';

class SubscribeButton extends StatelessWidget {
  const SubscribeButton({
    super.key,
    required this.alias,
    required this.isSubscribed,
  });

  final String alias;
  final bool isSubscribed;

  void onSubscribePressed(BuildContext context) {
    if (context.read<AuthCubit>().state.isAuthorized) {
      context.read<SubscriptionCubit>().toggleSubscription();
    } else {
      showLoginSnackBar(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubscriptionCubit(
        repository: getIt(),
        alias: alias,
        isSubscribed: isSubscribed,
      ),
      child: BlocConsumer<SubscriptionCubit, SubscriptionState>(
        listenWhen: (p, c) => p.status == LoadingStatus.failure,
        listener: (context, state) {
          context.showSnack(content: Text(state.error));
        },
        builder: (context, state) {
          var style = OutlinedButton.styleFrom(
            foregroundColor: context.theme.colors.accentPositive,
            side: BorderSide(color: context.theme.colors.accentPositive),
          );

          if (state.isSubscribed) {
            style = OutlinedButton.styleFrom(
              backgroundColor: context.theme.colors.accentPositive,
              foregroundColor: context.theme.colors.onAccentPositive,
              side: BorderSide.none,
            );
          }

          return OutlinedButton(
            style: style,
            onPressed: state.status == LoadingStatus.loading
                ? null
                : () => onSubscribePressed(context),
            child: Text(state.buttonText),
          );
        },
      ),
    );
  }
}
