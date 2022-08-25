import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../common/model/author_model.dart';
import '../../../component/router/router.dart';
import '../../../config/constants.dart';
import '../../user/widget/user_avatar_widget.dart';

class ArticleAuthorWidget extends StatelessWidget {
  const ArticleAuthorWidget(this.author, {Key? key}) : super(key: key);

  final AuthorModel author;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.navigateTo(ServicesRoute(
          children: [
            const AllServicesRoute(),
            const UserListRoute(),
            UserDetailRoute(
              key: ValueKey('user-${author.id}'),
              login: author.alias,
            ),
          ],
        ));
      },
      child: Row(
        children: [
          ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: const BorderRadius.all(
              Radius.circular(kBorderRadiusDefault),
            ),
            child: UserAvatarWidget(imageUrl: author.avatarUrl),
          ),
          const SizedBox(width: 8),
          Text(author.alias),
        ],
      ),
    );
  }
}
