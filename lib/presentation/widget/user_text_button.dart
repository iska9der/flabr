import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../core/component/router/app_router.dart';
import '../../data/model/user_base.dart';
import '../theme/theme.dart';
import 'card_avatar_widget.dart';
import 'dialog/dialog.dart';

class UserTextButton extends StatelessWidget {
  const UserTextButton(this.user, {super.key});

  final UserBase user;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: Theme.of(context).textButtonTheme.style!.copyWith(
        alignment: Alignment.centerLeft,
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
      ),
      onPressed: () {
        context.router.push(UserDashboardRoute(alias: user.alias));
      },
      onLongPress: () {
        showProfileDialog(context, child: UserProfileDialog(user: user));
      },
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          CardAvatarWidget(
            imageUrl: user.avatarUrl,
            height: AppDimensions.avatarPublicationHeight,
          ),
          const SizedBox(width: 8),
          Text(user.alias),
        ],
      ),
    );
  }
}
