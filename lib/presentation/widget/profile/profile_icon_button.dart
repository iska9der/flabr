import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/profile/profile_bloc.dart';
import '../../../data/model/loading_status_enum.dart';
import '../../extension/context.dart';
import '../card_avatar_widget.dart';
import '../dialog/dialog.dart';

class MyProfileIconButton extends StatelessWidget {
  const MyProfileIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProfileBloc>().state;

    return IconButton(
      onPressed: switch (state.status) {
        LoadingStatus.initial ||
        LoadingStatus.failure => () => showLoginDialog(context),
        LoadingStatus.success =>
          () => showProfileDialog(
            context,
            child: const MyProfileDialog(),
          ),
        _ => null,
      },
      icon:
          state.status == LoadingStatus.success
              ? CardAvatarWidget(
                imageUrl: state.me.avatarUrl,
                placeholderColor: context.theme.colorScheme.primary,
                height: context.theme.iconTheme.size ?? 24,
              )
              : const Icon(Icons.no_accounts_rounded),
    );
  }
}
