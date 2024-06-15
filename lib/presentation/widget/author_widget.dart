import 'package:flutter/material.dart';

import '../../core/component/di/injector.dart';
import '../../core/component/router/app_router.dart';
import '../../data/model/publication/publication_author_model.dart';
import '../feature/auth/widget/dialog.dart';
import '../feature/auth/widget/profile_widget.dart';
import '../theme/part.dart';
import 'card_avatar_widget.dart';

class AuthorWidget extends StatelessWidget {
  const AuthorWidget(this.author, {super.key});

  final PublicationAuthor author;

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
          UserDashboardRoute(alias: author.alias),
        ),
        onLongPress: () {
          showProfileDialog(
            context,
            child: DialogUserProfileWidget(user: author),
          );
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            CardAvatarWidget(imageUrl: author.avatarUrl),
            const SizedBox(width: 8),
            Text(author.alias),
          ],
        ),
      ),
    );
  }
}
