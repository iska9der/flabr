import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/auth/auth_cubit.dart';
import '../../../bloc/profile/profile_bloc.dart';
import '../../../core/component/router/app_router.dart';
import '../../../data/model/user_base.dart';
import '../../extension/extension.dart';
import '../../theme/theme.dart';
import '../card_avatar_widget.dart';

Future showProfileDialog(
  BuildContext context, {
  required UserDialog child,
}) async {
  return await showDialog(
    context: context,
    builder: (_) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Align(
        child: SizedBox(
          width: Device.getWidth(context) * .7,
          child: child,
        ),
      ),
    ),
  );
}

abstract class UserDialog extends StatelessWidget {
  const UserDialog({super.key});
}

class UserProfileDialog extends StatelessWidget implements UserDialog {
  const UserProfileDialog({super.key, required this.user});

  final UserBase user;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: context.theme.colors.card,
      child: UserCommonTileList(user: user),
    );
  }
}

class MyProfileDialog extends StatelessWidget implements UserDialog {
  const MyProfileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.read<ProfileBloc>().state.me;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.isUnauthorized) {
          Navigator.of(context).pop();
        }
      },
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: context.theme.colors.card,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            UserCommonTileList(user: profile),
            const Divider(height: 1, indent: 0),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 8,
              ),
              child: ElevatedButton(
                onPressed: () => context.read<AuthCubit>().logOut(),
                child: const Text('Выход'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserCommonTileList extends StatelessWidget {
  const UserCommonTileList({
    super.key,
    required this.user,
  });

  final UserBase user;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          leading: CardAvatarWidget(imageUrl: user.avatarUrl),
          title: Text('@${user.alias}'),
          subtitle: user.fullname.isNotEmpty ? Text(user.fullname) : null,
          onTap: () {
            context.router.push(UserDashboardRoute(alias: user.alias));

            Navigator.of(context).pop();
          },
        ),
        ListTile(
          title: const Text('Публикации'),
          onTap: () {
            context.router.push(
              UserDashboardRoute(
                alias: user.alias,
                children: [UserPublicationListRoute()],
              ),
            );

            Navigator.of(context).pop();
          },
        ),
        ListTile(
          title: const Text('Закладки'),
          onTap: () {
            context.router.push(
              UserDashboardRoute(
                alias: user.alias,
                children: [UserBookmarkListRoute()],
              ),
            );

            Navigator.of(context).pop();
          },
        ),
        ListTile(
          title: const Text('Комментарии'),
          onTap: () {
            context.router.push(
              UserDashboardRoute(
                alias: user.alias,
                children: [UserCommentListRoute()],
              ),
            );

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
