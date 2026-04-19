import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/profile/profile_bloc.dart';
import '../../extension/extension.dart';
import '../card_avatar_widget.dart';
import '../dialog/dialog.dart';

class MyProfileIconButton extends StatelessWidget {
  const MyProfileIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final state = context.watch<ProfileBloc>().state;

    return IconButton(
      onPressed: switch (state.status) {
        .initial || .failure => () => showLoginDialog(context),
        .success => () => showProfileDialog(
          context,
          child: const MyProfileDialog(),
        ),
        _ => null,
      },
      icon: state.status == .success
          ? CardAvatarWidget(
              imageUrl: state.me.avatarUrl,
              height: theme.iconTheme.size ?? 24,
            )
          : const Icon(Icons.no_accounts_rounded),
    );
  }
}
