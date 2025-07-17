import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/component/router/app_router.dart';
import '../../../data/model/user_base.dart';
import '../../../presentation/extension/extension.dart';
import '../../../presentation/widget/card_avatar_widget.dart';
import '../../../presentation/widget/enhancement/progress_indicator.dart';
import '../cubit/auth_cubit.dart';

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
      child: _UserCommonTiles(user: user),
    );
  }
}

class MyProfileDialog extends StatelessWidget implements UserDialog {
  const MyProfileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.isUnauthorized) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state.isUnauthorized) {
          return const SizedBox();
        }

        if (state.status.isLoading || state.me.isEmpty) {
          return const CircleIndicator.medium();
        }

        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: context.theme.colors.card,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _UserCommonTiles(user: state.me),
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
        );
      },
    );
  }
}

class _UserCommonTiles extends StatelessWidget {
  const _UserCommonTiles({
    // ignore: unused_element_parameter
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
