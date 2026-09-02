import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../bloc/profile/profile_bloc.dart';
import '../../../i18n/i18n.dart';
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

        final titleText = profile.isEmpty
            ? context.t.settings.account.title
            : profile.alias;
        final subtitleText = profile.isEmpty
            ? context.t.settings.account.notLoggedIn
            : profile.fullname;

        return Skeletonizer(
          enabled: state.status == .loading,
          child: ListTile(
            tileColor: theme.colors.card,
            contentPadding: const .symmetric(horizontal: 12),
            title: Text(titleText),
            subtitle: Text(subtitleText),
            leading: switch (profile.isEmpty) {
              true => const Icon(
                Icons.no_accounts_rounded,
                size: AppDimensions.avatarHeight,
              ),
              false => CardAvatarWidget(imageUrl: profile.avatarUrl),
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
