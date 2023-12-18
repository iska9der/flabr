import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../../common/widget/feed/card_avatar_widget.dart';
import '../../../../auth/widget/dialog.dart';
import '../../../../auth/widget/profile_widget.dart';
import '../../../model/publication_author_model.dart';

class PublicationAuthorWidget extends StatelessWidget {
  const PublicationAuthorWidget(this.author, {super.key});

  final PublicationAuthorModel author;

  @override
  Widget build(BuildContext context) {
    return TextButtonTheme(
      data: const TextButtonThemeData(
        style: ButtonStyle(alignment: Alignment.centerLeft),
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
