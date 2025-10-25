import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../bloc/profile/profile_bloc.dart';
import '../../../data/model/loading_status_enum.dart';
import '../../extension/extension.dart';
import '../../theme/theme.dart';
import '../card_avatar_widget.dart';
import '../dialog/dialog.dart';

class AccountTile extends StatelessWidget {
  const AccountTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final profile = state.me;

        final titleText = profile.isEmpty ? 'Аккаунт' : profile.alias;
        final subtitleText = profile.isEmpty ? 'Вы не вошли' : profile.fullname;

        return Skeletonizer(
          enabled: state.status == LoadingStatus.loading,
          child: ListTile(
            tileColor: theme.colors.card,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            title: Text(titleText),
            subtitle: Text(subtitleText),
            leading: switch (profile.isEmpty) {
              true => const Icon(
                Icons.no_accounts_rounded,
                size: AppDimensions.avatarHeight,
              ),
              false => CardAvatarWidget(
                imageUrl: profile.avatarUrl,
                placeholderColor: theme.colorScheme.primary,
              ),
            },
            onTap: switch (profile.isEmpty) {
              true => () => showLoginDialog(context),
              false => () => showProfileDialog(
                context,
                child: const MyProfileDialog(),
              ),
            },
          ),
        );
      },
    );
  }
}
