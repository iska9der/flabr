import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/component/router/app_router.dart';
import '../../../data/model/user_base.dart';
import '../../../presentation/extension/extension.dart';
import '../../../presentation/widget/card_avatar_widget.dart';
import '../../../presentation/widget/enhancement/card.dart';
import '../../../presentation/widget/enhancement/progress_indicator.dart';
import '../cubit/auth_cubit.dart';

abstract class DialogUserWidget extends StatelessWidget {
  const DialogUserWidget({super.key});
}

class DialogUserProfileWidget extends StatelessWidget
    implements DialogUserWidget {
  const DialogUserProfileWidget({
    super.key,
    required this.user,
  });

  final UserBase user;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: FlabrCard(
        elevation: 0,
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListTile(
                leading: CardAvatarWidget(imageUrl: user.avatarUrl),
                title: Text('@${user.alias}'),
                subtitle: user.fullname.isNotEmpty ? Text(user.fullname) : null,
                onTap: () {
                  context.router.push(
                    UserDashboardRoute(alias: user.alias),
                  );

                  Navigator.of(context).pop();
                },
              ),
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
        ),
      ),
    );
  }
}

class DialogMyProfileWidget extends StatelessWidget
    implements DialogUserWidget {
  const DialogMyProfileWidget({super.key});

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

        return IntrinsicHeight(
          child: FlabrCard(
            elevation: 0,
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DialogUserProfileWidget(user: state.me),
                const Divider(height: 1),
                ElevatedButton(
                  onPressed: () => context.read<AuthCubit>().logOut(),
                  child: const Text('Выход'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
