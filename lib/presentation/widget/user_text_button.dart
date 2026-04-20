import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../core/component/router/router.dart';
import '../../data/model/user_base.dart';
import '../theme/theme.dart';
import 'card_avatar_widget.dart';
import 'dialog/dialog.dart';

class UserTextButton extends StatelessWidget {
  const UserTextButton(
    this.user, {
    super.key,
    this.subtitle,
  });

  final UserBase user;
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const .new(-6, 0),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const .symmetric(horizontal: 6, vertical: 0),
        ),
        onPressed: () {
          context.router.push(UserDashboardRoute(alias: user.alias));
        },
        onLongPress: () {
          showProfileDialog(context, child: UserProfileDialog(user: user));
        },
        child: Wrap(
          crossAxisAlignment: .center,
          children: [
            CardAvatarWidget(
              imageUrl: user.avatarUrl,
              height: AppDimensions.avatarPublicationHeight,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              children: [
                Text(user.alias),
                if (subtitle != null) subtitle!,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
