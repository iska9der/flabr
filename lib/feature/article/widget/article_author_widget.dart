import 'package:flutter/material.dart';

import '../../../common/model/author_model.dart';
import '../../../common/utils/utils.dart';
import '../../../common/widget/network_image_widget.dart';
import '../../../component/di/dependencies.dart';
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
        /// todo: navigate to user
        getIt.get<Utils>().showNotification(
              context: context,
              content: const Text('Тишинаааа...'),
            );
      },
      child: Row(
        children: [
          ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            child: author.avatarUrl.isNotEmpty
                ? NetworkImageWidget(
                    url: 'https:${author.avatarUrl}',
                    height: avatarHeight,
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
        size: avatarHeight,
      ),
    );
  }
}
