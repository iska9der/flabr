import 'package:flutter/material.dart';

import '../../core/component/di/injector.dart';
import '../../core/component/router/app_router.dart';
import '../../data/model/user_base.dart';
import '../feature/auth/widget/dialog.dart';
import '../feature/auth/widget/profile_widget.dart';
import '../theme/part.dart';
import 'card_avatar_widget.dart';

class UserTextButton extends StatelessWidget {
  const UserTextButton(this.user, {super.key});

  final UserBase user;

  @override
  Widget build(BuildContext context) {
    return TextButtonTheme(
      data: TextButtonThemeData(
        style: ButtonStyle(
          alignment: Alignment.centerLeft,
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadiusDefault),
            ),
          ),
        ),
      ),
      child: TextButton(
        onPressed: () => getIt<AppRouter>().navigate(
          UserDashboardRoute(alias: user.alias),
        ),
        onLongPress: () {
          showProfileDialog(
            context,
            child: DialogUserProfileWidget(user: user),
          );
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            CardAvatarWidget(imageUrl: user.avatarUrl),
            const SizedBox(width: 8),
            Text(user.alias),
          ],
        ),
      ),
    );
  }
}
