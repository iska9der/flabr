import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../config/constants.dart';
import '../../feature/auth/widget/dialog.dart';
import '../../feature/auth/widget/profile_widget.dart';
import '../../feature/publication/model/publication_author_model.dart';
import 'feed/card_avatar_widget.dart';

class AuthorWidget extends StatelessWidget {
  const AuthorWidget(this.author, {super.key});

  final PublicationAuthorModel author;

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
        onPressed: () {
          context.navigateNamedTo('services/users/${author.alias}');
        },
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
