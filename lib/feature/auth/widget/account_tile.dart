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
    final authState = context.select<AuthCubit, AuthState>((c) => c.state);
    final titleText =
        authState.me.alias.isEmpty ? 'Аккаунт' : authState.me.alias;
    final subtitleText =
        authState.me.fullname.isEmpty ? 'Вы не вошли' : authState.me.fullname;

    return ListTile(
      tileColor: context.theme.colors.card,
      title: Text(titleText),
      subtitle: Text(subtitleText),
      leading:
          authState.isAuthorized
              ? CardAvatarWidget(
                imageUrl: authState.me.avatarUrl,
                placeholderColor: context.theme.colorScheme.primary,
              )
              : Icon(
                Icons.no_accounts_rounded,
                size: AppDimensions.avatarHeight,
              ),
      onTap:
          authState.isAuthorized
              ? () => showProfileDialog(
                context,
                child: const DialogMyProfileWidget(),
              )
              : () => showLoginDialog(context),
    );
  }
}
