import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../common/model/author_model.dart';
import '../../../common/widget/network_image_widget.dart';
import '../../../component/router/router.gr.dart';
import '../../../config/constants.dart';

class ArticleAuthorWidget extends StatelessWidget {
  const ArticleAuthorWidget(this.author, {Key? key}) : super(key: key);

  final AuthorModel author;

  Widget onLoading(BuildContext context, String url) =>
      const _PlaceholderAvatar();

  Widget onError(BuildContext context, String url, error) =>
      const _PlaceholderAvatar();

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
            child: author.avatarUrl.isNotEmpty
                ? NetworkImageWidget(
                    imageUrl: 'https:${author.avatarUrl}',
                    height: kAvatarHeight,
                    placeholderWidget: onLoading,
                    errorWidget: onError,
                  )
                : const _PlaceholderAvatar(),
          ),
          const SizedBox(width: 8),
          Text(author.alias),
        ],
      ),
    );
  }
}

class _PlaceholderAvatar extends StatelessWidget {
  const _PlaceholderAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Icon(
        Icons.account_box_rounded,
        color: Theme.of(context).colorScheme.onSurface,
        size: kAvatarHeight,
      ),
    );
  }
}
