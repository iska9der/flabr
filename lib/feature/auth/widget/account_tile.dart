import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../presentation/extension/extension.dart';
import '../../../presentation/theme/theme.dart';
import '../../../presentation/widget/card_avatar_widget.dart';
import '../cubit/auth_cubit.dart';
import 'dialog.dart';
import 'profile_widget.dart';

class AccountTile extends StatelessWidget {
  const AccountTile({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.select<AuthCubit, AuthState>((cubit) => cubit.state);
    final titleText = state.me.alias.isEmpty ? 'Аккаунт' : state.me.alias;
    final subtitleText =
        state.me.fullname.isEmpty ? 'Вы не вошли' : state.me.fullname;

    return ListTile(
      tileColor: context.theme.colors.card,
      title: Text(titleText),
      subtitle: Text(subtitleText),
      leading:
          state.isAuthorized
              ? CardAvatarWidget(
                imageUrl: state.me.avatarUrl,
                placeholderColor: context.theme.colorScheme.primary,
              )
              : Icon(
                Icons.no_accounts_rounded,
                size: AppDimensions.avatarHeight,
              ),
      onTap:
          state.isAuthorized
              ? () => showProfileDialog(
                context,
                child: const DialogMyProfileWidget(),
              )
              : () => showLoginDialog(context),
    );
  }
}
