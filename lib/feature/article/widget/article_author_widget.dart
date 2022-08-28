import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../model/article_author_model.dart';
import '../../user/widget/user_avatar_widget.dart';

class ArticleAuthorWidget extends StatelessWidget {
  const ArticleAuthorWidget(this.author, {Key? key}) : super(key: key);

  final ArticleAuthorModel author;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.navigateNamedTo('services/users/${author.alias}');
      },
      child: Row(
        children: [
          UserAvatarWidget(imageUrl: author.avatarUrl),
          const SizedBox(width: 8),
          Text(author.alias),
        ],
      ),
    );
  }
}
