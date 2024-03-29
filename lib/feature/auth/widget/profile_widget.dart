import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/model/extension/enum_status.dart';
import '../../../common/model/user.dart';
import '../../../common/widget/enhancement/card.dart';
import '../../../common/widget/enhancement/progress_indicator.dart';
import '../../../common/widget/feed/card_avatar_widget.dart';
import '../../user/page/user_bookmark_list_page.dart';
import '../../user/page/user_comment_list_page.dart';
import '../../user/page/user_publication_list_page.dart';
import '../cubit/auth_cubit.dart';

abstract class DialogUserWidget extends StatelessWidget {
  const DialogUserWidget({super.key});
}

class DialogUserProfileWidget extends StatelessWidget
    implements DialogUserWidget {
  const DialogUserProfileWidget({super.key, required this.user});

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
            ListTile(
              leading: CardAvatarWidget(imageUrl: user.avatarUrl),
              subtitle: user.fullname.isNotEmpty ? Text(user.fullname) : null,
              title: Text('@${user.alias}'),
              onTap: () {
                context.navigateNamedTo(
                  'services/users/${user.alias}',
                );

                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Публикации'),
              onTap: () {
                context.navigateNamedTo(
                  'services/users/${user.alias}/${UserPublicationListPage.routePath}',
                );

                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Закладки'),
              onTap: () {
                context.navigateNamedTo(
                  'services/users/${user.alias}/${UserBookmarkListPage.routePath}',
                );

                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Комментарии'),
              onTap: () {
                context.navigateNamedTo(
                  'services/users/${user.alias}/${UserCommentListPage.routePath}',
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
